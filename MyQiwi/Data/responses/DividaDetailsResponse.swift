//
//  DividaDetailsResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DividaDetailsResponse : BasePojo {
    
    @objc dynamic var idTransition: Int = 0
    @objc dynamic var prvId: Int = 0
    @objc dynamic var productName: String = ""
    @objc dynamic var valueTransition: Double = 0
    @objc dynamic var valueService: Double = 0
    @objc dynamic var valueComission: Double = 0
    @objc dynamic var dateCreation: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(prvId: Int, name: String, value: Double, commission: Double, date: String) {
        self.init()
        
        self.prvId = prvId
        self.productName = name
        self.valueTransition = value
        self.valueComission = commission
        self.dateCreation = date
    }
    
    override func mapping(map: Map) {
        idTransition <- map["id_transacao"]
        prvId <- map["id_prv"]
        productName <- map["nome_produto"]
        valueTransition <- map["valor_transacao"]
        valueService <- map["valor_servico"]
        dateCreation <- map["data_criacao"]
        valueComission <- map["comissao"]
    }
}

