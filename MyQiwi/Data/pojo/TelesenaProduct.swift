//
//  TelesenaProduct.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class TelesenaProduct: BasePojo {

    @objc dynamic var edition: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var value: Int = 0

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        edition <- map["edicao"]
        name <- map["produto"]
        desc <- map["descricao"]
        value <- map["valorUnitario"]
    }
}

