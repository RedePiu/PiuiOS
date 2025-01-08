//
//  RequestTelesena.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestTelesena : BasePojo {
    
    @objc dynamic var edition: String = ""
    @objc dynamic var cpf: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var amount: Int = 1
    @objc dynamic var value: Int = 0

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        edition <- map["Edicao"]
        cpf <- map["Cpf"]
        phone <- map["Telefone"]
        amount <- map["Quantidade"]
        value <- map["ValorUnitario"]
    }
}

