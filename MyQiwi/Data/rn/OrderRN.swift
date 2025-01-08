//
//  OrderRN.swift
//  MyQiwi
//
//  Created by ailton on 22/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation

class OrderRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    public func getOrderList(startFrom: Int) {
        
        var orders = [Order]()
        
        // Create request
        let objectData = GetOrderListBody(startFrom: startFrom)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedOrderList, json: serviceBody)
        
        callApiForList(Order.self, request: request) { (orderResponse) in
            
            //If failed to get the baptism response
            if orderResponse.sucess {
                orders = (orderResponse.body?.data)!
                
//                orders[1].hasCashback = true
//                orders[1].cashbackValue = 3200
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportCardRN.self, param: Param.Contact.ORDERS_ORDER_LIST_RESPONSE,
                             result: orderResponse.sucess, object: orders as AnyObject)
        }
    }
    
    public func getOrderPix(orderNumber: Int, order: Order? = nil) {
        // Create request
        let objectData = GetOrderBody(orderId: orderNumber)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetPix, json: serviceBody)
        
        callApi(ConsultaPIX.self, request: request) { (orderResponse) in
            if orderResponse.sucess {
                if order != nil
                {
                    let array: [Any] = [orderResponse.body?.data, order]
                    self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_PIX_RESPONSE,
                                     result: orderResponse.sucess, object: (array) as AnyObject)
                } else {
                    self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_PIX_RESPONSE,
                                     result: orderResponse.sucess, object: (orderResponse.body?.data)! as AnyObject)
                }
            } else {
                self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_PIX_RESPONSE,result: orderResponse.sucess)
            }
        }
    }
    
    public func getOrder(orderNumber: Int) {
        // Create request
        let objectData = GetOrderBody(orderId: orderNumber)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedOrderStatus, json: serviceBody)
        
        callApi(Order.self, request: request) { (orderResponse) in
            if orderResponse.sucess {
                //verificar se não é transação PIX nova
                let order = orderResponse.body?.data
                if order?.paymentMethod.rawValue == ActionFinder.Payments.PIX && order?.status == .pendent {
                    self.getOrderPix(orderNumber: orderNumber, order: order)
                } else {
                    self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_ORDER_RESPONSE,
                                     result: orderResponse.sucess, object: (orderResponse.body?.data)! as AnyObject)
                }
            } else {
                self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_ORDER_RESPONSE,result: orderResponse.sucess)
            }
        }
    }
    
    public func getTransaction(transactionId: Int) {
        // Create request
        let objectData = GetTransactionBody(transactionId: transactionId)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTransactionStatus, json: serviceBody)
        
        callApi(Order.self, request: request) { (orderResponse) in
            if orderResponse.sucess {
                self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_TRANSACTION_RESPONSE,
                                 result: orderResponse.sucess, object: (orderResponse.body?.data)! as AnyObject)
            } else {
                self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_TRANSACTION_RESPONSE,result: orderResponse.sucess)
            }
        }
    }
    
    public func getTransactionNew(transactionId: Int, transitionDate: String) {
        // Create request
        let objRequest = GetTransactionNewBody(transitionId: transactionId, date: transitionDate)
        let serviceBody = updateJsonWithHeader(jsonBody: objRequest.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedNewTransactionStatus, json: serviceBody)
        
        callApi(Order.self, request: request) { (orderResponse) in
            if orderResponse.sucess {
                self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_TRANSACTION_RESPONSE,
                                 result: orderResponse.sucess, object: (orderResponse.body?.data)! as AnyObject)
            } else {
                self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_TRANSACTION_RESPONSE,result: orderResponse.sucess)
            }
        }
    }
    
    public func sendOrderComplement(orderId: Int, caixaCode: String) {
        
        // Create request
        let objectData = ComplementOrderBody(orderId: orderId, complement: caixaCode)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedComplementOrder, json: serviceBody)
        
        callApi(request: request) { (response) in

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDERS_SEND_COMPLEMENT_RESPONSE,
                             result: response.sucess)
        }
    }
    
    public func confirmCashback(orderId: Int) {
        // Create request
        let objectData = CashbackBody(orderId: orderId)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedCashback, json: serviceBody)
        var result = false
        
        callApiDataBool(request: request) { (response) in
            
            if response.sucess {
                result = response.body?.data ?? false
            }
            
            self.sendContact(fromClass: OrderRN.self, param: Param.Contact.ORDER_CASHBACK_CONFIRMATON, result: result)
        }
    }
}
