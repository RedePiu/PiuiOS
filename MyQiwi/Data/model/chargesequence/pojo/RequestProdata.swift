//
//  RequestProdata.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 05/11/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestProdata : BasePojo {
    
    var cardNumber: Int?
    @objc dynamic var creditTypeId: Int = 0
    @objc dynamic var prodCode: Int = 0

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cardNumber <- map["numero_cartao"]
        creditTypeId <- map["cod_tipo_credito"]
        prodCode <- map["cod_produto"]
    }
}
