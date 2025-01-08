//
//  RequestMetrocard.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestMetrocard : BasePojo {
    
    @objc dynamic var userId: Int = 0
    @objc dynamic var productId: Int = 0
    @objc dynamic var card: String = ""
    @objc dynamic var cpf: String = ""
    @objc dynamic var unitValue: Int = 0

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        card <- map["Cartao"]
        cpf <- map["cpf"]
        userId <- map["IdComprador"]
        productId <- map["idProduto"]
        unitValue <- map["ValorUnitario"]
    }
}
