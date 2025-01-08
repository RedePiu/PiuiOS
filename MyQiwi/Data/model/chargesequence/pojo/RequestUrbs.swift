//
//  RequestUrbs.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 01/07/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestUrbs: BasePojo {
    
    @objc dynamic var cardType: String = ""
    @objc dynamic var cardNumber: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cardType <- map["codigoTipoCartao"]
        cardNumber <- map["idCartao"]
    }
    
    convenience init(cardType: String, cardNumber: String) {
        self.init()
        
        self.cardType = cardType
        self.cardNumber = cardNumber
    }
}
