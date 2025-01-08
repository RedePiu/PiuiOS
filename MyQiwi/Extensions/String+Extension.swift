//
//  String+Extension.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 23/04/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func substring(from: Int, to: Int) -> String {
        let newTo = to - from
        return (self as NSString).substring(with: NSRange(location: from, length: newTo))
    }
    
    func substring(_ from: Int,_ to: Int) -> String {
        return substring(from: from, to: to)
    }
    
    func substring(_ from: Int) -> String {
        return substring(from: from, to: self.count)
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func getCharIndex(char: String) -> Int {
        
        for i in 0..<self.count {
            if self.substring(i, i+1) == char {
                return i
            }
        }
        
        return -1
    }
    
    func addAttributedString(_ fontDefault: UIFont, _ fontCustom: UIFont) -> NSMutableAttributedString? {
        
        if let comma = self.index(of: " ") {
            
            let range = comma...
            let nsRange = NSRange(range, in: self)
            let formated = NSMutableAttributedString(string: self, attributes: [.font : fontDefault])
            formated.addAttribute(.font, value: fontCustom, range: nsRange)
            
            return formated
        }
        
        return NSMutableAttributedString(string: self, attributes: [.font : fontDefault])
    }
    
    /**
     * Formats a String into a pre defined format. E.G. Text: 12345678921 Format: ###.###.###-## = return 123.456.789-21
     *
     * @param text   The text to formats
     * @param format A specific format to convert the text. Use '#' to represent the characters,
     *               any other character won't be changed. E.G: ###.###.###-## for a CPF or ##/##/## for a date.
     * @return The formatted String or null if text is null/empty.
     */
    func formatText(format: String) -> String {
        var currentIndex = 0
        var formattedText = ""
        
        for i in 0..<format.count {
            
            //texto ja foi finalizado
            if currentIndex >= self.count {
                return formattedText
            }
            
            //se nao for um #, adiciona o caracter original
            if format[i] != "#" {
                formattedText = formattedText + format[i]
                continue
            }
            
            formattedText = formattedText + self[currentIndex]
            currentIndex = currentIndex + 1
        }
        
        return formattedText
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(startIndex, offsetBy: r.lowerBound)
        let end = self.index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[(start ..< end)])
    }
    
    func isEmail() -> Bool {
        
        do {
            
            let regex = try NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: [.caseInsensitive])
            return regex.firstMatch(in: self, options: .withTransparentBounds, range: NSMakeRange(0, self.count)) != nil
            
        } catch {
            debugPrint("Erro isEmail: \(error.localizedDescription)")
        }
        
        return false
    }
    
    func passwordValid() -> Bool {
        
        // Minimo = 1 letra minúscula, Minimo = 1 letra maiúscula, Minimo = 1 numero, Minimo de 8 caracteres e maximo de 20 caracteres
        do {
            
            let regex = try NSRegularExpression(pattern: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,20}$", options: [])
            return regex.firstMatch(in: self, options: .withTransparentBounds, range: NSMakeRange(0, self.count)) != nil
            
        } catch {
            debugPrint("Error PasswordValid: \(error.localizedDescription)")
        }
        
        return false
    }
    
    func isCount(_ limite: Int) -> Bool {
        
        return self.count < limite
    }
    
    func containsSpace() -> Bool {
        
        return self.contains(" ")
    }
    
    func removeAllOtherCaracters() -> String {
        
        let listCaracters = [",",".","-","(",")"," ","+","\n","/"]
        var text = self
        
        for caracterText in text {
            for caracterBlackList in listCaracters {
                if caracterText.description == caracterBlackList {
                    if let index = text.index(of: caracterText) {
                        text.remove(at: index)
                    }
                }
            }
        }
        
        return text
    }
    
    func removeAllBars() -> String {
        
        let listCaracters = ["\\"]
        var text = self
        
        for caracterText in text {
            for caracterBlackList in listCaracters {
                if caracterText.description == caracterBlackList {
                    if let index = text.index(of: caracterText) {
                        text.remove(at: index)
                    }
                }
            }
        }
        
        return text
    }
    
    func removeAllCaractersExceptNumbers() -> String {
        
        let result = self.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
        return result
    }
    
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
    
    mutating func removeSpace() -> String {
        
        let listCaracters = [" "]
        var text = self
        
        for caracterText in text {
            for caracterBlackList in listCaracters {
                if caracterText.description == caracterBlackList {
                    if let index = text.index(of: caracterText) {
                        text.remove(at: index)
                    }
                }
            }
        }
        
        return text
    }
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "R$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(
            in: amountWithPrefix,
            options: NSRegularExpression.MatchingOptions(rawValue: 0),
            range: NSMakeRange(0, self.count),
            withTemplate: ""
        )
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        var value = formatter.string(from: number)!
        value = value.replacingOccurrences(of: "R$", with: "R$ ")
        
        return value
    }
    
    // formatting text for currency textField
    func currencyInputFormatting(currency: String) -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        //formatter.currencySymbol = "R$"
        formatter.currencyCode = currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        var value = formatter.string(from: number)!
        //value = value.replacingOccurrences(of: "R$", with: "R$ ")
        
        return value
    }
    
    var isValidCPF: Bool {
        let numbers = self.compactMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        let dv1 = soma1 > 9 ? 0 : soma1
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        let dv2 = soma2 > 9 ? 0 : soma2
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
    
    var isValidCNPJ: Bool {
        let numbers = compactMap({ Int(String($0)) })
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
            var number = 1
            let digit = 11 - slice.reversed().reduce(into: 0) {
                number += 1
                $0 += $1 * number
                if number == 9 { number = 1 }
                } % 11
            return digit > 9 ? 0 : digit
        }
        let dv1 = digitCalculator(numbers.prefix(12))
        let dv2 = digitCalculator(numbers.prefix(13))
        return dv1 == numbers[12] && dv2 == numbers[13]
    }
    
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}
