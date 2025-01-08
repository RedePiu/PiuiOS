//
//  RequestPhoneRecharge.swift
//  MyQiwi
//
//  Created by ailton on 16/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestPhoneRecharge: BasePojo {
    
    @objc dynamic var operatorId: Int = 0
    @objc dynamic var tel: String = ""
    @objc dynamic var ddd: String = ""
    @objc dynamic var categoryId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        operatorId <- map["operadoraID"]
        tel <- map["telefone"]
        ddd  <- map["ddd"]
        categoryId  <- map["categoria_id"]
    }
}
