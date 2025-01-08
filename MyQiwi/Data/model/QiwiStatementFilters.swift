//
//  QiwiStatementFilters.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class QiwiStatementFilters {
    
    var filter: Filter = .LAST_15_DAYS
    var month: Int = Date().month
    var year: Int = Date().year
    
    /**
    *@monthAndYear a date in mm/yyyy format
    */
    func setDate(monthAndYear: String) {
        self.month = Int(monthAndYear.substring(0, 2)) ?? Date().month
        self.year = Int(monthAndYear.substring(3, monthAndYear.count)) ?? Date().year
    }
    
    func getFilterName() -> String {
        
        switch (self.filter) {
            case .LAST_15_DAYS: return "qiwi_statement_last_15_days".localized
            case .LAST_30_DAYS: return "qiwi_statement_last_30_days".localized
            case .MONTH:
                
            //Verifica qual o mes
            return self.getMonthName()
        }
    }
    
    func getMonthName() -> String {
        var monthName: String
        
        switch (self.month) {
            case 1: monthName = "Janeiro"
            case 2: monthName = "Fevereiro"
            case 3: monthName = "Março"
            case 4: monthName = "Abril"
            case 5: monthName = "Maio"
            case 6: monthName = "Junho"
            case 7: monthName = "Julho"
            case 8: monthName = "Agosto"
            case 9: monthName = "Setembro"
            case 10: monthName = "Outubro"
            case 11: monthName = "Novembro"
            case 12: monthName = "Dezembro"
            default: monthName = ""
        }
        
        return monthName + " de " + String(year)
    }
}

extension QiwiStatementFilters {
    
    public enum Filter: Int {
        case LAST_15_DAYS = 1
        case LAST_30_DAYS = 2
        case MONTH = 3
    }
}
