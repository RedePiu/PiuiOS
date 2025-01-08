//
//  BillRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class BillRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func requestBillDetails(barCode: String, isScan: Bool, value: Int) {
        
        let billDetailsBody = BillDetailsBody(barcode: barCode, value: value, isScan: isScan)
        let serviceBody = updateJsonWithHeader(jsonBody: billDetailsBody.generateJsonBody())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedBillConsult, json: serviceBody)
        
        callApi(BillDetailsResponse.self, request: request) { (response) in
            
            self.sendContact(fromClass: BillRN.self, param: Param.Contact.BILL_REQUEST_RESPONSE, result: response.sucess, object: response as AnyObject)
        }
    }
    
    /**
    * Irá atualizar a variavel QiwiOrder.billType
    */
    func verifyPaymentType() {
        if !QiwiOrder.isBillPayment() {
            return
        }
        
        let paymentType = PaymentTypeDAO().getByType(idSlipType: (QiwiOrder.factoryFebraban?.getTipoBoleto().rawValue)!)
        if paymentType.prvId > 0 {
            QiwiOrder.setPrvId(prvId: paymentType.prvId)
        }
    }
}
