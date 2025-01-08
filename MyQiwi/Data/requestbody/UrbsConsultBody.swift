//
//  UrbsConsultBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class UrbsConsultBody : BasePojo {
    
    @objc dynamic var cardNumber: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cardNumber <- map["id_cartao"]
    }
    
    convenience init(cardNumber: String) {
        self.init()
        
        self.cardNumber = cardNumber
    }
}
