//
//  ProdutoProdata.swift
//  MyQiwi
//
//  Created by Daniel Catini on 04/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class ProdutoProdata: BasePojo {

    @objc dynamic var prvId: Int = 0
    @objc dynamic var id_emissor: Int = 0
    
    override public static func primaryKey() -> String? {
        return "prvId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        prvId <- map["id_prv"]
        id_emissor <- map["id_emissor"]
    }
}
