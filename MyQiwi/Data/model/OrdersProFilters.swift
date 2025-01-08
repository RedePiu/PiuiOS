//
//  OrdersProFilters.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 16/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class OrdersProFilters {
    
    var filter: Filter = .LAST_DAY
    var day: Int = Date().day
    var month: Int = Date().month
    var year: Int = Date().year
    var date: Date = Date()
    
    /**
    *@monthAndYear a date in mm/yyyy format
    */
    func setDate(monthAndYear: String) {
        self.month = Int(monthAndYear.substring(0, 2)) ?? Date().month
        self.year = Int(monthAndYear.substring(3, monthAndYear.count)) ?? Date().year
    }
    
    func SetCompleteDate(date: Date) {
        self.date = date
        self.day = date.day
        self.month = date.month
        self.year = date.year
    }
    
    func getFilterName() -> String {
        
        switch (self.filter) {
            case .LAST_DAY: return "qiwi_statement_last_day".localized
            case .LAST_7_DAYS: return "qiwi_statement_last_7_days".localized
            case .LAST_15_DAYS: return "qiwi_statement_last_15_days".localized
            case .LAST_30_DAYS: return "qiwi_statement_last_30_days".localized
            case .DAY: return DateFormatterQiwi.formatDate(date: self.date, format: "dd 'de' MMMM 'de' yyyy")
            case .MONTH:

            //Verifica qual o mes
            return self.getMonthName()
        }
     //   return ""
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

extension OrdersProFilters {
    
    public enum Filter: Int {
        case LAST_DAY = 1
        case LAST_7_DAYS = 2
        case LAST_15_DAYS = 3
        case LAST_30_DAYS = 4
        case DAY = 5
        case MONTH = 6
    }
}
