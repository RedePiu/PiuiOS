//
//  CheckoutRN.swift
//  MyQiwi
//
//  Created by Ailton on 20/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FirebaseCore
import FirebaseAnalytics

class CheckoutRN : BaseRN {
    
    var timer: Timer?
    var mOrderId: Int?
    var mTimerCount = 0
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    public func sendCheckoutRequest() {
        let generatePass = QiwiOrder.checkoutBody.transition?.qiwiBalance != nil || QiwiOrder.checkoutBody.transition?.prePago != nil
        var seq = BaseRN.GENERATE_SEQUENCE
        
        //Se o banco náo tiver nome, devemos enviar vazio
        if QiwiOrder.checkoutBody.transition?.bankRequest != nil &&
            (QiwiOrder.checkoutBody.transition?.bankRequest?.ownerName.isEmpty)! && QiwiOrder.checkoutBody.transition?.bankRequest?.bankId != ActionFinder.Bank.SANTANDER {
            QiwiOrder.checkoutBody.transition?.bankRequest?.ownerName = "Vazio"
        }
        
        // Create request
        if generatePass || QiwiOrder.isQiwiTransfer() {
            let bodyHeader = generateBodyHeader(EmptyObject.self, data: nil, seq: BaseRN.GENERATE_SEQUENCE, generateSignutre: false)
            seq = bodyHeader.seq
            let pass = QiwiOrder.qiwiPass
            let newPass = RestHelper.getQiwiPW(pass: pass, seq: seq)
            
            if QiwiOrder.checkoutBody.transition?.prePago != nil {
                QiwiOrder.checkoutBody.transition?.prePago?.pass = newPass
            } else {
                QiwiOrder.checkoutBody.transition?.qiwiBalance?.pass = newPass
            }
        }
        
        let loc = LocationHelper()
        QiwiOrder.checkoutBody.transition?.latitude = loc.getLocation().coordinate.latitude
        QiwiOrder.checkoutBody.transition?.longitude = loc.getLocation().coordinate.longitude
        
        //Se nao encontrar latitude e longitude, adiciona a padrao da qiwi
        if QiwiOrder.checkoutBody.transition?.latitude == 0 && QiwiOrder.checkoutBody.transition?.longitude == 0 {
            QiwiOrder.checkoutBody.transition?.latitude = -23.557939
            QiwiOrder.checkoutBody.transition?.longitude = -46.662122
        }
        
        print(QiwiOrder.checkoutBody.toJSONString())
        
        // Create request
        let serviceBody = updateJsonWithHeader(jsonBody: QiwiOrder.checkoutBody.toJSONString() ?? "", seq: seq)
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedCheckoutRequest, json: serviceBody)
        
        callApi(CreateOrderResponse.self, request: request) { (response) in
            
            //Qiwi pass is wrong!
            if response.body != nil && response.body?.cod == ResponseCodes.USER_QIWI_PASS_WRONG {
                self.sendContact(fromClass: CheckoutRN.self, param: Param.Contact.USER_QIWI_PASS_WRONG_ERROR)
                return
            }
            
            var orderResponse: CreateOrderResponse?
            if response.sucess {
                
                orderResponse = response.body?.data
//                AppEvents.logPurchase(Double(QiwiOrder.checkoutBody.transition?.transitionValue/100), currency: "BRL")
                //AppEvent.purchased(amount: am0ount, currency: "", extraParameters: parameters)
                
                if QiwiOrder.checkoutBody.transition?.bankRequest != nil || QiwiOrder.checkoutBody.transition?.pix != nil {
                    let order = Order()
                    order.id = (orderResponse?.id)!
                    
                    //Atualiza user info
                    UserRN(delegate: self).callAndUpdateUserInfo{ response in
                    }
                    
                    self.sendContact(fromClass: CheckoutRN.self, param: Param.Contact.CHECKOUT_REQUEST,
                                     result: (orderResponse != nil && (orderResponse?.status)!.rawValue != CreateOrderResponse.Status.canceled.rawValue), object: order)
                    return
                }
                
                self.mOrderId = orderResponse?.id
                
                if QiwiOrder.checkoutBody.transition?.pix_v2 != nil {
                    let order = Order()
                    order.id = (orderResponse?.id)!
                    
                    //Atualiza user info
                    UserRN(delegate: self).callAndUpdateUserInfo { response in
                    }
                    
                    let contexto = PixContexto(order: order)
                    
                    DispatchQueue.main.async {
                        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self,
                                selector: #selector(self.callOrderPix(timer:)), userInfo: contexto, repeats: true)
                    }
                    
                    return
                }
                
                //fazer timer para checar a cada 2s o status
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 3, target: self,
                                                      selector: #selector(self.callOrderStatus), userInfo: nil, repeats: true)
                }
                return
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: CheckoutRN.self, param: Param.Contact.CHECKOUT_REQUEST_FAILED,
                             result: response.sucess, object: orderResponse?.status?.rawValue as AnyObject)
        }
    }
    
    struct PixContexto {
        let order: Order
    }
    
    @objc func callOrderPix(timer: Timer) {
        if let contexto = timer.userInfo as? PixContexto {
            mTimerCount = mTimerCount + 1
            let orderRN = OrderRN(delegate: self)
            orderRN.getOrderPix(orderNumber: mOrderId!, order: contexto.order)
        }
    }
    
    @objc func callOrderStatus() {
        mTimerCount = mTimerCount + 1
        let orderRN = OrderRN(delegate: self)
        orderRN.getOrder(orderNumber: mOrderId!)
    }
    
    /**
     * Check in database if a prv has taxes. A response will be sent throw CHECKOUT_CHECK_TAX_RESPONSE.
     * @param prvId The product's prvId.
     */
    func checkTaxes(prvId: Int) {
        let taxes = TaxesDAO().getAll(prvid: prvId)
        sendContact(fromClass: CheckoutRN.self, param: Param.Contact.CHECKOUT_CHECK_TAX_RESPONSE, result: !taxes.isEmpty, object: taxes as AnyObject)
    }
    
    /**
     * Check in database if a prv has taxes.
     * @prvId: The product's prvId
     * @paymentType: The payment type from ActionFinder.Payments.
     */
    func checkTaxesForPaymentMethod(prvId: Int, paymentType: Int) -> Tax {
        let taxes = TaxesDAO().getAll(prvid: prvId)
        
        return verifyTaxes(taxes: taxes, paymentType: paymentType)
    }
    
    func verifyTaxes(taxes: [Tax], paymentType: Int) -> Tax {
        
        var newTax = Tax()
        
        if taxes.isEmpty {
            return Tax()
        }
        
        for tax in taxes {
            if tax.value > 0 && (tax.paymentTypeId == paymentType || tax.paymentTypeId == ActionFinder.Payments.ANY_PAYMENT) {
                return tax
            }
            newTax = tax
        }
        
        return newTax
    }
    
    func getValueWithTax(tax: Tax, value: Int) -> Int {
        
        var valueAux = value
        
        if tax.value <= 0 {
            return value
        }
        
        //1 deve ser incrementado
        if tax.salestaxOperation == 1 {
            if tax.isFixed {
                valueAux = valueAux + Int(tax.value * 100)
            } else {
                valueAux = valueAux + Int(Double(value) * (tax.value/100))
            }
        }
            //2 deve diminuir
        else if tax.salestaxOperation == 2 {
            
            if tax.isFixed {
                valueAux = valueAux - Int(tax.value * 100)
            } else {
                valueAux = valueAux - Int(Double(value) * (tax.value/100))
            }
        }
        
        return valueAux
    }
    
    func getValueWithTaxText(tax: Tax, value: Int) -> String {
        
        var taxValue = Util.formatCoin(value: value)
        
        if tax.value <= 0 {
            return taxValue
        }
        
        //1 deve ser incrementado
        if tax.salestaxOperation == 1 {
            if tax.isFixed {
                taxValue = "+ \(Util.formatCoin(value: tax.value))"
            } else {
                taxValue = "+ \(Util.formatCoin(value: tax.value))%"
            }
        }
            //2 deve diminuir
        else if tax.salestaxOperation == 2 {
            
            if tax.isFixed {
                taxValue = "- \(Util.formatCoin(value: tax.value))"
            } else {
                taxValue = "- \(Util.formatCoin(value: tax.value))%"
            }
        }
        
        return taxValue
    }
    
    //AuthenticatedResendReceipt
    func resendReceipt(phone: String, orderId: Int) {
        let objRequest = ResendReceiptBody(phone: phone.removeAllOtherCaracters(), orderId: orderId)
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedResendReceipt, json: serviceBody)
        
        callApi(EmptyObject.self, request: request) { (response) in

            self.sendContact(fromClass: CheckoutRN.self, param: Param.Contact.CHECKOUT_RESEND_RECEIPT_RESPONSE, result: response.sucess)
        }
    }
}

extension CheckoutRN: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if fromClass == OrderRN.self {
                if param == Param.Contact.ORDERS_ORDER_RESPONSE {
                    if result {
                        let order = object as! Order
                        if self.mTimerCount == 6 || order.status != Order.Status.pendent {
                            self.timer?.invalidate()
                            
                            if order.status != Order.Status.canceled {
                                //Gets the value for purchase
                                let value = Double(QiwiOrder.getValue()) / 100
                                //Log Purchases on facebook
                                AppEvents.logPurchase(value, currency: "BRL")
                                //Log Purchases on Firebase AnalyticsEventPurchase
                                
    //                                Analytics.logEvent(AnalyticsEventEcommercePurchase, parameters: [
    //                                    AnalyticsParameterItemID: String(QiwiOrder.getPrvID()),
    //                                    AnalyticsParameterItemName: QiwiOrder.productName,
    //                                    AnalyticsParameterCurrency: "BRL",
    //                                    AnalyticsParameterValue: value
    //                                  ]
    //                                )
                            }
                            
                            self.sendContact(fromClass: CheckoutRN.self, param: Param.Contact.CHECKOUT_REQUEST, result: (order.status != Order.Status.canceled), object: order)
                        }
                    } else {
                        self.sendContact(fromClass: CheckoutRN.self, param: Param.Contact.CHECKOUT_REQUEST, result: false)
                    }
                }
                else if param == Param.Contact.ORDERS_PIX_RESPONSE {
                    if result {
                        let array = (object as! Array<Any>)
                        let order = (array[0] as! ConsultaPIX)
                        //let order = object as! ConsultaPIX
                        if self.mTimerCount == 6 || order.qrCodePayload != "" {
                            self.timer?.invalidate()
                            
                            self.sendContact(fromClass: CheckoutRN.self, param: Param.Contact.CHECKOUT_REQUEST_PIX, result: true, object: object)
                        }
                    } else {
                        self.sendContact(fromClass: CheckoutRN.self, param: Param.Contact.CHECKOUT_REQUEST_PIX, result: false)
                    }
                }
            }
        }
    }
}
