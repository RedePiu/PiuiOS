//
//  ReceiptRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class ReceiptRN : BaseRN {
    
    
    static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getReceipts(daysBack: Int) {
        
        //let yearsToAdd = -1
        let currentDate = Date()
        
        var dateComponent = DateComponents()
        //dateComponent.year = yearsToAdd
        dateComponent.day = -daysBack
        
        let fromDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        getReceipts(fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: currentDate))
    }
    
    func getReceipts(month: Int, year: Int) {
        
        var dateComponent = DateComponents()
        dateComponent.setValue(month, for: .month)
        dateComponent.setValue(year, for: .year)
        dateComponent.setValue(1, for: .day)
        dateComponent.setValue(0, for: .hour)
        dateComponent.setValue(0, for: .minute)
        dateComponent.setValue(0, for: .second)
        
        var toDateComponent = dateComponent
        toDateComponent.year = 0
        toDateComponent.month = 1 //pula um mes
        toDateComponent.day = -1 //volta 1 dia
        toDateComponent.setValue(0, for: .hour)
        toDateComponent.setValue(0, for: .minute)
        toDateComponent.setValue(0, for: .second)
        
        let fromDate = Calendar.current.date(from: dateComponent)
        let toDate = Calendar.current.date(byAdding: toDateComponent, to: fromDate!)
        
        getReceipts(fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: toDate!))
    }
    
    func getReceipts(fromDate: String, toDate: String) {
        var receiptGroup: [ReceiptGroup] = []
        
        // Create request
        //let consultBody = ReceiptListBody(fromDate: "2019-03-21T11:31:29", toDate: "2019-03-25T09:53:43")
        let consultBody = ReceiptListBody(fromDate: fromDate, toDate: toDate)
        
        //At this case JSON must be ordened with a specific order.
        //updateJsonWithHeader must be called with generateJsonBody
        //A data object will be returned to send to the server
        let serviceBody = updateJsonWithHeader(jsonBody: consultBody.generateJsonBody())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetReceipts, json: serviceBody)
        
        callApiForList(ReceiptGroup.self, request: request) { (receiptResponses) in
            
            //If failed to get the baptism response
            if receiptResponses.sucess {
                receiptGroup = (receiptResponses.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: ReceiptRN.self, param: Param.Contact.QIWI_STATEMENT_RESPONSE,
                             result: receiptResponses.sucess, object: receiptGroup as AnyObject)
        }
    }
    
    func generateReceiptGroup(receipts: [Receipt]) -> [ReceiptGroup] {
        var groups = [ReceiptGroup]()
        let group = ReceiptGroup()
        group.date = "2019-04-04T00:00:00"
        group.receipts = receipts
        
        groups.append(group)
        return groups
    }
}
