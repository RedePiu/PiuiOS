//
//  PhoneFormatter.swift
//  MyQiwi
//
//  Created by ailton on 03/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

public class PhoneFormatter {
    
    public static func splitDDDFromNumber(phoneContact: PhoneContact) -> PhoneContact {
        
        var number = phoneContact.number
        var ddd = ""
        
        number = number.removeAllOtherCaracters()
        
        if hasDDI(phoneNumber: number) {
            let subStringDDI = number.substring(2)
            number = String(subStringDDI)
        }
        
        if hasDDD(phoneNumber: number) {
            let subStringDDD = number.prefix(2)
            ddd = String(subStringDDD)
            
            let newNumber = number.suffix(9)
            number = String(newNumber)
        }
        
        phoneContact.ddd = ddd
        phoneContact.number = number
        return phoneContact
    }
    
    public static func splitDDDFromNumber(phoneContact: String) -> PhoneContact {
        
        var number = phoneContact
        var ddd = ""
        
        number = number.removeAllOtherCaracters()
        
        if hasDDI(phoneNumber: number) {
            let subStringDDI = number.substring(2)
            number = String(subStringDDI)
        }
        
        if hasDDD(phoneNumber: number) {
            let subStringDDD = number.prefix(2)
            ddd = String(subStringDDD)
            
            let newNumber = number.suffix(9)
            number = String(newNumber)
        }
        
        return PhoneContact(name: "", ddd: ddd, number: number)
    }
    
    public static func hasDDI(phoneNumber: String) -> Bool {
        if phoneNumber.isEmpty {
            return false
        }
        
        return phoneNumber.contains("+") || phoneNumber.count > 11
    }
    
    public static func hasDDD(phoneNumber: String) -> Bool {
        if phoneNumber.isEmpty {
            return false
        }
        
        let cleanNumber = phoneNumber
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
        
        return cleanNumber.count > 9
    }
}
