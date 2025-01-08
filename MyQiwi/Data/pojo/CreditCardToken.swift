
//
//  CreditCardToken.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

//import RealmSwift
import ObjectMapper

class CreditCardToken: BasePojo {

    @objc dynamic var tokenId: Int = 0
    @objc dynamic var digits: Int = 0
    @objc dynamic var brand: String = ""
    @objc dynamic var nickname: String = ""
    
    override public static func primaryKey() -> String? {
        return "tokenId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        tokenId <- map["id_token"]
        digits <- map["digitos"]
        brand <- map["bandeira"]
        nickname <- map["Apelido_Cartao"]
    }
    
    convenience init(tokenId: Int) {
        self.init()
        
        self.tokenId = tokenId
    }
    
    func getListLabel() -> String {
        var label = self.nickname
        
        if !label.isEmpty {
            label += " - "
        }
        
        return label + "final " + self.getLastDigits() + ""
    }
    
    func getLastDigits() -> String {
        let stringDigits = String(digits)
        
        if stringDigits.count < 5 {
            return stringDigits
        }
        
        return String(stringDigits.suffix(4))
    }

    func getStringDigits() -> String {
        
        let stringDigits = String(digits)
        
        if stringDigits.count < 5 {
            return stringDigits
        }
        
        let startInitialIndex = stringDigits.index(stringDigits.startIndex, offsetBy: 3)
        let initialDigits = stringDigits[stringDigits.startIndex...startInitialIndex]
        
        let startCentralIndex = stringDigits.index(startInitialIndex, offsetBy: 5)
        let centralDigits = stringDigits[startInitialIndex...startCentralIndex]
        
        let finalDigits = stringDigits[startCentralIndex...]
        
        return String(format: "%@ %@** **** %@", String(initialDigits), String(centralDigits), String(finalDigits))
        
        // AJUSTAR ESTA FUNCAO O RETORNO DO CARTAO ESTA SEM A MASCARA CORRETA
    }
    
    func isMaster() -> Bool {
        return brand.uppercased().contains("MASTER")
    }
    
    func isVisa() -> Bool {
        return brand.uppercased().contains("VISA")
    }
}
