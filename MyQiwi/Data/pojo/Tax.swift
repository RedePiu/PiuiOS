//
//  Tax.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//


import ObjectMapper
//import RealmSwift

class Tax: BasePojo {

    @objc dynamic var id: Int = 0
    @objc dynamic var prvId: Int = 0
    @objc dynamic var salestaxOperation: Int = 0
    @objc dynamic var isFixed: Bool = false
    @objc dynamic var value: Double = 0
    @objc dynamic var paymentTypeId: Int = 0
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        prvId <- map["PrvID"]
        salestaxOperation <- map["SalesTaxOperation"]
        isFixed <- map["IsFixed"]
        value <- map["Value"]
        paymentTypeId <- map["id_tipo_pagamento"]
    }
}
