//
//  TransportCardConsultBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//
import ObjectMapper

class TransportCardConsultBody : BasePojo {
    
    @objc dynamic var cardNumber : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cardNumber <- map["id_cartao"]
    }
    
    convenience init(cardNumber: Int) {
        self.init()
        
        self.cardNumber = String(cardNumber)
    }
}
