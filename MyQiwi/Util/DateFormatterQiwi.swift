//
//  DateFormatterQiwi.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class DateFormatterQiwi {
    
    public static let defaultDatePattern = "yyyy-MM-dd'T'HH:mm:ss"
    public static let defaultDateWithoutTPattern = "yyyy-MM-dd HH:mm:ss"
    public static let urbsPattern = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    public static let registerPattern = "yyyy-MM-dd"
    public static let dateAndHour = "dd/MM/yy 'as' HH:mm"
    public static let dateBrazil = "dd/MM/yyyy"
    
    static func stringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatterQiwi.defaultDatePattern
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from:date)!
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        
        return calendar.date(from:components)!
    }
    
    static func currentDate() -> String {
        let date = Date()
        return formatDate(date: date)
    }
    
    static func formatDate(date: Date) -> String {
        return formatDate(date:date, format: defaultDatePattern)
    }
    
    static func formatDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = format
        
        return dateFormatterOut.string(from: date)
    }
    
    static func formatDate(_ currentDate: String, currentFormat: String, toFormat: String) -> String {
        let index = currentDate.prefix(19)
        
        //2018-09-26T22:00:16
        let dateFormatterIn = DateFormatter()
        dateFormatterIn.dateFormat = currentFormat
        
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = toFormat
        
        if let dateServer = dateFormatterIn.date(from: String(index)) {
            return dateFormatterOut.string(from: dateServer)
        } else {
            return ""
        }
    }
}
