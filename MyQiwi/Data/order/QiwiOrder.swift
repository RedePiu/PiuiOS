//
//  QiwiOrder.swift
//  MyQiwi
//
//  Created by Ailton on 14/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class QiwiOrder {
    
    static var checkoutBody = CheckoutBody()
    static var selectedMenu = MenuItem()
    static var date = ""
    static var type = ""
    static var details = ""
    static var productName = ""
    static var qiwiPass = ""
    static var productDesc = ""
    static var transportTypeSelected: TransportTypeResponse?
    static var transportTypeCittaMobiSelected: TransportCittaMobiTypeResponse?
    static var transportProdataProduct: TransportProdataProduct?
    static var urbsBalanceSelected: UrbsBalance?
    static var phoneContactSelected: PhoneContact?
    static var billType = ActionFinder.Bill.CONSUMO
    static var isScan = false
    static var factoryFebraban: FactoryFebraban?
    static var userBalance = 0
    static var delegate: BaseDelegate?
    static var clickBusCharge: BusTicketCharge?
    static var minValue: Int = 0 //Usar quando precisar
    static var maxValue: Int = 0 //Usar quando precisar
    static var internationalPhoneValueList: [InternationalValue]?
    static var coupons: [Coupon]?
    static var adressName: String = ""
    static var latitude: Double = 0
    static var longitude: Double = 0
    
    // MARK: - PrvID BEM
    static var instructionsViewIsHidden = Bool()
    
    static func sendContact(param: Int) {
        self.sendContact(param: param, result: true, objects: nil)
    }
    
    static func sendContact(param: Int, objects: AnyObject?) {
        self.sendContact(param: param, result: true, objects: objects)
    }
    
    static func sendContact(param: Int, result: Bool, objects: AnyObject?) {
        self.delegate?.onReceiveData(fromClass: QiwiOrder.self, param: param, result: result, object: objects)
    }
    
    static func startQiwiChargeOrder() {
        QiwiOrder.clearFields()
        QiwiOrder.checkoutBody.requestQiwiCharge = QiwiChargeBody()
        QiwiOrder.productName = "qiwi_recharge_toolbar_title".localized
        QiwiOrder.setPrvId(prvId: ActionFinder.QIWI_BALANCE_RECHARGE_PRVID)
    }
    
    static func startQiwiTransferForPrePago() {
        QiwiOrder.clearFields()
        QiwiOrder.checkoutBody.requestQiwiTransferForPrePago = RequestQiwiTransferForPrePago()
        QiwiOrder.checkoutBody.transition?.qiwiBalance = QiwiBalanceRequest()
        QiwiOrder.productName = "qiwi_transfer_prepago_toolbar_title".localized
        QiwiOrder.setPrvId(prvId: ActionFinder.QIWI_BALANCE_TRANSFER_FOR_PREPAGO_PRVID)
    }
    
    static func getPaymentType() -> Int {
        if checkoutBody.transition?.bankRequest != nil {
            return ActionFinder.Payments.BANK_TRANSFER
        }
        
        if checkoutBody.transition?.token != nil {
            return ActionFinder.Payments.CREDIT_CARD
        }
        
        if checkoutBody.transition?.qiwiBalance != nil {
            return ActionFinder.Payments.QIWI_BALANCE
        }
        
        if checkoutBody.transition?.prePago != nil {
            return ActionFinder.Payments.PRE_PAGO_LIMIT_AND_TAX
        }
        
        if checkoutBody.transition?.pix != nil {
            return ActionFinder.Payments.PIX
        }
        
        if checkoutBody.transition?.pix_v2 != nil {
            return ActionFinder.Payments.PIX
        }
        
        return 0
    }
    
    static func getPrvID() -> Int {
        return checkoutBody.transition?.prvId ?? 0
    }
    
    static func getValue() -> Int {
        return checkoutBody.transition?.value ?? 0
    }
    
    static func getTransitionValue() -> Int {
        return checkoutBody.transition?.transitionValue ?? 0
    }
    
    static func isQiwiRecharge() -> Bool {
        return checkoutBody.requestQiwiCharge != nil
    }
    
    static func isTransportRecharge() -> Bool {
        return checkoutBody.requestTransport != nil
    }
    
    static func isTransportCittaMobiRecharge() -> Bool {
        return checkoutBody.requestTransportCittaMobi != nil
    }
    
    static func isTransportProdataRecharge() -> Bool {
        return checkoutBody.requestProdata != nil
    }
    
    static func isMetrocardRecharge() -> Bool {
        return checkoutBody.requestMetrocard != nil
    }
    
    static func isUltragaz() -> Bool {
        return checkoutBody.requestUltragaz != nil
    }
    
    static func isTaxaCampo() -> Bool {
        return checkoutBody.requestTaxaCampo != nil
    }
    
    static func isDonation() -> Bool {
        return checkoutBody.requestDonation != nil
    }
    
    static func isBilheteUnicoComum() -> Bool {
        if !QiwiOrder.isTransportRecharge() {
            return false
        }
        
        return ActionFinder.isBilheteUnicoComum(id: (QiwiOrder.checkoutBody.requestTransport?.rechargeType)!) ||
            ActionFinder.isBilheteUnicoEstudanteComum(id: (QiwiOrder.checkoutBody.requestTransport?.rechargeType)!)
    }
    
    static func isDrTerapia() -> Bool {
        return QiwiOrder.checkoutBody.requestDrTerapia != nil
    }
    
    static func isTelesena() -> Bool {
        return QiwiOrder.checkoutBody.requestTelesena != nil
    }
    
    static func isClickBus() -> Bool {
        return QiwiOrder.checkoutBody.requestClickbus != nil
    }
    
    static func isClickBusOnlyIda() -> Bool {
        return QiwiOrder.clickBusCharge != nil && QiwiOrder.clickBusCharge!.isOnlyGo
    }
    
    static func isClickBusIdaEVolta() -> Bool {
        return !QiwiOrder.isClickBusOnlyIda()
    }
    
    static func isPhoneRecharge() -> Bool {
        return checkoutBody.requestPhone != nil
    }
    
    static func isInternationalPhoneRecharge() -> Bool {
        return checkoutBody.requestInternationalPhone != nil
    }
    
    static func isBillPayment() -> Bool {
        return checkoutBody.requestBill != nil
    }
    
    static func isQiwiCharge() -> Bool {
        return checkoutBody.requestQiwiCharge != nil
    }
    
    static func isRvCharge() -> Bool {
        return checkoutBody.requestRv != nil
    }
    
    static func isRvSpotifyCharge() -> Bool {
        return checkoutBody.requestRvSpotify != nil
    }
    
    static func isIncommCharge() -> Bool {
        return checkoutBody.requestIncomm != nil
    }
    
    static func isPinofflineCharge() -> Bool {
        return checkoutBody.requestPinoffline != nil
    }
    
    static func isQiwiTransfer() -> Bool {
        return checkoutBody.creditQiwiTransferRequest != nil
    }
    
    static func isUrbsCharge() -> Bool {
        return checkoutBody.requestUrbs != nil
    }
    
    static func isQiwiTransferToPrePago() -> Bool {
        return checkoutBody.requestQiwiTransferForPrePago != nil
    }
    
    static func isCPFConsult() -> Bool {
        return selectedMenu.action == ActionFinder.ACTION_CONSULTA_CPF
    }
    
    static func isCNPJConsult() -> Bool {
        return selectedMenu.action == ActionFinder.ACTION_CONSULTA_CNPJ
    }
    
    static func isPayingWithBankTransfer() -> Bool {
        return checkoutBody.transition?.bankRequest != nil
    }
    
    static func isPayingWithPIX() -> Bool {
            return checkoutBody.transition?.pix != nil
    }
    
    static func isPayingWithQiwiCredit() -> Bool {
        return checkoutBody.transition?.qiwiBalance != nil
    }
    
    static func isPayingWithCreditCard() -> Bool {
        return checkoutBody.transition?.token != nil
    }
    
    static func isPayingWithPrePago() -> Bool {
        return checkoutBody.transition?.prePago != nil
    }
    
    static func isPayingWithCoupon() -> Bool {
        return checkoutBody.transition?.coupons != nil
    }
    
    static func getTransportCardtype() -> Int {
        if QiwiOrder.isTransportRecharge() {
            return ActionFinder.Transport.CardType.BILHETE_UNICO
        }
        else if QiwiOrder.isTransportCittaMobiRecharge() {
            return ActionFinder.Transport.CardType.NOSSO
        }
        else if QiwiOrder.isMetrocardRecharge() {
            return ActionFinder.Transport.CardType.METROCARD
        }
        else if QiwiOrder.isTransportProdataRecharge() {   
            if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.NossoRibeirao.CIDADAO {
                return ActionFinder.Transport.CardType.NOSSO
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.BemLegalMaceio.COMUM {
                return ActionFinder.Transport.CardType.BEM_LEGAL
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.SaoVicente.COMUM {
                return ActionFinder.Transport.CardType.SAO_VICENTE
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.SaoCarlos.COMUM {
                return ActionFinder.Transport.CardType.SAO_CARLOS
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.SaoSebastiao.COMUM {
                return ActionFinder.Transport.CardType.SAO_SEBASTIAO
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Caieiras.COMUM {
                return ActionFinder.Transport.CardType.CAIEIRAS
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Araraquara.COMUM {
                return ActionFinder.Transport.CardType.ARARAQUARA
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.PresidentePrudente.COMUM {
                return ActionFinder.Transport.CardType.PRESIDENTE_PRUDENTE
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Indaiatuba.COMUM {
                return ActionFinder.Transport.CardType.INDAIATUBA
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Limeira.COMUM {
                return ActionFinder.Transport.CardType.LIMEIRA
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Osasco.COMUM {
                return ActionFinder.Transport.CardType.OSASCO
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.FrancodaRocha.COMUM {
                return ActionFinder.Transport.CardType.FRANCO_ROCHA
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.SantanadeParnaiba.COMUM {
                return ActionFinder.Transport.CardType.SANTANA_PARNAIBA
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Cajamar.COMUM {
                return ActionFinder.Transport.CardType.CAJAMAR
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.RioClaro.COMUM {
                return ActionFinder.Transport.CardType.RIO_CLARO
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.Araraquara.COMUM {
                return ActionFinder.Transport.CardType.ARARAQUARA
            } else  if QiwiOrder.selectedMenu.prvID == ActionFinder.Transport.Prodata.PresidentePrudente.COMUM {
                return ActionFinder.Transport.CardType.PRESIDENTE_PRUDENTE
            } else {
                return ActionFinder.Transport.CardType.RAPIDO_TAUBATE
            }
        }
        else {
            return ActionFinder.Transport.CardType.URBS
        }
    }

    /*
    * When a order is done, use this function to clear the object
    */
    static func clearFields() {
        checkoutBody = CheckoutBody()
        selectedMenu = MenuItem()
        date = ""
        type = ""
        details = ""
        productName = ""
        qiwiPass = ""
        billType = ActionFinder.Bill.CONSUMO
        isScan = false
        delegate = nil
        minValue = 0
        maxValue = 0
        latitude = 0
        longitude = 0
        
        transportTypeSelected = nil
        transportTypeCittaMobiSelected = nil
        phoneContactSelected = nil
        urbsBalanceSelected = nil
        clickBusCharge = nil
        internationalPhoneValueList = nil
    }
    
    static func clearPaymentMethods() {
        checkoutBody.transition?.token = nil
        checkoutBody.transition?.bankRequest = nil
        checkoutBody.transition?.pix = nil
        checkoutBody.transition?.qiwiBalance = nil
        checkoutBody.transition?.coupons = nil
        coupons = nil
    }

    /*
     * Updates the description, based on name and and value. Must be called after defines a name and transition value
     *
     */
    static func updateDesc(value: Int) {
        switch QiwiOrder.productName {
        case "phone_product_name".localized:
            QiwiOrder.details = "\("phone_product_desc".localized) \(Util.formatCoin(value: value))"
            return
        case "bill_barcode_title_nav".localized:
            QiwiOrder.details = "\("bill_checkout_desc".localized) \(Util.formatCoin(value: value))"
            return
            
        case "qiwi_recharge_toolbar_title".localized:
            QiwiOrder.details = "\("qiwi_recharge_desc".localized) \(Util.formatCoin(value: value))"
            
        case "cpf_consult_toolbar_title".localized:
            QiwiOrder.details = "\("cpf_consult_toolbar_desc".localized) \(Util.formatCoin(value: value))"
            
        case "cnpj_consult_toolbar_title".localized:
            QiwiOrder.details = "\("cnpj_consult_toolbar_desc".localized) \(Util.formatCoin(value: value))"
        return
            
        case "cittamobi_product_name".localized:
            QiwiOrder.details = "\("cittamobi_product_desc".localized) \(Util.formatCoin(value: value))"
            return
            
        case "urbs_product_name".localized:
            QiwiOrder.details = "\("urbs_product_desc".localized) \(Util.formatCoin(value: value))"
            return
            
        case "qiwi_transfer_prepago_toolbar_title".localized:
        QiwiOrder.details = "\("qiwi_transfer_prepago_checkout_details".localized) \(Util.formatCoin(value: value))"
            return
            
        case "clickbus_product_name".localized:
            var clickbusDesc = ""
            
            if QiwiOrder.isClickBusOnlyIda() {
                clickbusDesc = "clickbus_product_detail".localized
                    .replacingOccurrences(of: "{destiny_amount}", with: String(QiwiOrder.clickBusCharge?.amountTicketGo ?? 0))
                    .replacingOccurrences(of: "{destiny}", with: QiwiOrder.clickBusCharge!.cityDestiny?.name ?? "")
                    .replacingOccurrences(of: "{destiny_value}", with: Util.formatCoin(value: QiwiOrder.clickBusCharge!.getTotalValueForDestiny()))
                    .replacingOccurrences(of: "{total}", with: Util.formatCoin(value: value))
            } else {
                clickbusDesc = "clickbus_product_detail_go_and_returning".localized
                .replacingOccurrences(of: "{destiny_amount}", with: String(QiwiOrder.clickBusCharge?.amountTicketGo ?? 0))
                .replacingOccurrences(of: "{destiny}", with: QiwiOrder.clickBusCharge!.cityDestiny?.name ?? "")
                .replacingOccurrences(of: "{destiny_value}", with: Util.formatCoin(value: QiwiOrder.clickBusCharge!.getTotalValueForDestiny()))
                .replacingOccurrences(of: "{departure_amount}", with: String(QiwiOrder.clickBusCharge?.amountTicketBack ?? 0))
                .replacingOccurrences(of: "{departure}", with: QiwiOrder.clickBusCharge!.cityDeparture?.name ?? "")
                .replacingOccurrences(of: "{departure_value}", with: Util.formatCoin(value: QiwiOrder.clickBusCharge!.getTotalValueForReturning()))
                .replacingOccurrences(of: "{total}", with: Util.formatCoin(value: value))
            }
            
            QiwiOrder.details = clickbusDesc
            return
            
        case "metrocard_product_name".localized:
        QiwiOrder.details = "\("metrocard_product_desc".localized) \(Util.formatCoin(value: value))"
            return
            
        case "dr_terapia_product_name".localized:
        QiwiOrder.details = "dr_terapia_checkout_details".localized
            .replacingOccurrences(of: "{desc}", with: QiwiOrder.productDesc)
        .replacingOccurrences(of: "{value}", with: Util.formatCoin(value: value))
            return
            
        default:
            
            if QiwiOrder.isUltragaz() {
                QiwiOrder.details = "\("ultragaz_products_details".localized.replacingOccurrences(of: "{product}", with: productName)) \(Util.formatCoin(value: value))"
                return
            }
            
            if QiwiOrder.isTaxaCampo(){
                QiwiOrder.details = "\("ultragaz_products_details".localized.replacingOccurrences(of: "{product}", with: productName)) \(Util.formatCoin(value: value))"
            }
            
            QiwiOrder.details = "\("other_services_product_desc".localized) \(Util.formatCoin(value: value))"
        }
    }
    
    /*
     * Updates the latitude and longitude to the current location. Call this func before finish a order
     */
    static func updateLocation() {
        QiwiOrder.checkoutBody.transition?.updateLocation()
    }
    
    /*
     * Defines the prvid of the transition
     */
    static func setPrvId(prvId : Int) {
        checkoutBody.transition?.prvId = prvId
    }
    
    /*
     * Defines the value and transition value of the transition
     */
    static func setTransitionAndValue(value : Double) {
        setTransitionAndValue(value: Int(value * 100))
    }
    
    /*
     * Defines the value and transition value of the transition
     */
    static func setTransitionAndValue(value : Int) {
        checkoutBody.transition?.transitionValue = value
        checkoutBody.transition?.value = value
        
        //updateDesc(value: value)
    }
    
    /*
     * Defines the transition value of the transition (which includes tax)
     */
    static func setTransitionValue(value : Int) {
        checkoutBody.transition?.transitionValue = value
        
        //updateDesc(value: value)
    }
    
    /*
     * Defines the transition value of the transition
     */
    static func setValue(value : Int) {
        checkoutBody.transition?.value = value
    }
    
    /*
     * Defines the product name and the product type strings for checkout screen
     */
    static func setOrderInfo(productName : String, productType : String) {
        QiwiOrder.productName = productName
        QiwiOrder.type = type
    }
    
    /*
     * Defines the qiwipass that user entered at some point
     */
    static func setQiwiPass(qiwiPass : String) {
        QiwiOrder.qiwiPass = qiwiPass
    }
}
