//
//  Log.swift
//  ApprovalApp
//
//  Created by BlendMobi on 25/04/18.
//  Copyright © 2018 Blend IT. All rights reserved.
//

import UIKit

class Log {
    
    public enum TypePrint: Int {
        case `default`
        case alert
        case warning
    }
    
    static func print(_ items: Any..., typePrint: TypePrint = TypePrint.default, separator: String = " ", terminator: String = "\n", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        
        #if DEBUG
        
            let prefix = modePrefix(Date(), file: file, function: function, line: line)
            let stringItem = items.map {"\($0)"} .joined(separator: separator)
        
            var messageAlert = ""
            switch typePrint {
            case .default:
                messageAlert = "🔵"
            case .alert:
                messageAlert = "🚨"
            case .warning:
                messageAlert = "🛑"
            }
        
            Swift.print("\n\n\(messageAlert) \(prefix)\(stringItem) \n\n", terminator: terminator)
        #endif
    }
}


extension Log {
    
    fileprivate static func modePrefix(_ date: Date, file: String, function: String, line: Int) -> String {
        
        var result: String = ""

        let filename = file.lastPathComponent.stringByDeletingPathExtension
        
        result += "\(filename)."
        
        result += "\(function)"
        
        result += "[\(line)]"
        
        if !result.isEmpty {
            result = result.trimmingCharacters(in: CharacterSet.whitespaces)
            result += ": "
        }
        
        return result
    }
}


extension String {
    
    fileprivate var ns: NSString {
        return self as NSString
    }
    fileprivate var lastPathComponent: String {
        return ns.lastPathComponent
    }
    fileprivate var stringByDeletingPathExtension: String {
        return ns.deletingPathExtension
    }
}
