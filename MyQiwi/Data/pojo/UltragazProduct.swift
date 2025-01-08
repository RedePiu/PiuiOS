//
//  UltragazProduct.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 18/05/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class UltragazProduct: BasePojo {
    
    @objc dynamic var id: String = ""
    @objc dynamic var value: Double = 0
    @objc dynamic var name: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["codeProduct"]
        value <- map["priceProduct"]
        name <- map["nameProduct"]
    }
    
    convenience init(id: String, value: Double, name: String) {
        self.init()
        self.id = id
        self.value = value
        self.name = name
    }
}
