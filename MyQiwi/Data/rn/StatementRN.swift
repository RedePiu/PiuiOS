//
//  StatementRN.swift
//  MyQiwi
//
//  Created by Ailton on 17/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import SwiftDate

class StatementRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getStatementList(daysBack: Int, isPrePago: Bool = false) {
        
        //let yearsToAdd = -1
        let currentDate = Date()
        
        var dateComponent = DateComponents()
        //dateComponent.year = yearsToAdd
        dateComponent.day = -daysBack
        
        let fromDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        getStatementList(fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: currentDate), isPrePago: isPrePago)
    }
    
    func getStatementList(month: Int, year: Int, isPrePago: Bool = false) {
        
        var dateComponent = DateComponents()
        dateComponent.setValue(month, for: .month)
        dateComponent.setValue(year, for: .year)
        dateComponent.setValue(1, for: .day)
        
        var toDateComponent = dateComponent
        toDateComponent.year = 0
        toDateComponent.month = 1 //pula um mes
        toDateComponent.day = -1 //volta 1 dia
        
        let fromDate = Calendar.current.date(from: dateComponent)
        let toDate = Calendar.current.date(byAdding: toDateComponent, to: fromDate!)
        
        getStatementList(fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: toDate!), isPrePago: isPrePago)
    }
    
    func getStatementList(fromDate: String, toDate: String, isPrePago: Bool = false) {
        var statements: [Statement] = []
        
        // Create request
        //let consultBody = QiwiStatement(fromDate: "2017-10-17T11:42:40", toDate: "2018-10-17T11:42:40")
        let consultBody = QiwiStatement(fromDate: fromDate, toDate: toDate)
        
        //At this case JSON must be ordened with a specific order.
        //updateJsonWithHeader must be called with generateJsonBody
        //A data object will be returned to send to the server
        let serviceBody = updateJsonWithHeader(jsonBody: consultBody.generateJsonBody())
    
        let url = isPrePago ? BaseURL.AuthenticatedStatementsPrePago : BaseURL.AuthenticatedStatements
        let request = RestApi().generedRequestPost(url: url, json: serviceBody)
        
        callApiForList(Statement.self, request: request) { (statementResponses) in
            
            //If failed to get the baptism response
            if statementResponses.sucess {
                statements = (statementResponses.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: StatementRN.self, param: Param.Contact.QIWI_STATEMENT_RESPONSE,
                             result: statementResponses.sucess, object: statements as AnyObject)
        }
    }
}
