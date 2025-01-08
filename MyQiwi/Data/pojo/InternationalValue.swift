//
//  InternationalValue.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 01/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class InternationalValue: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var value: Double = 0
    @objc dynamic var originalValue: Double = 0
    @objc dynamic var currency: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["idProduto"]
        value <- map["valor"]
        originalValue <- map["valorOriginal"]
        currency <- map["currency"]
    }
    
    convenience init(id: Int, value: Double, originalValue: Double, currency: String) {
        self.init()
        self.id = id
        self.value = value
        self.originalValue = originalValue
        self.currency = currency
    }
}
