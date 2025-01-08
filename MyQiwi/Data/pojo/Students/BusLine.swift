//
//  BusLine.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 26/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class BusLine : BasePojo {
    
    @objc dynamic var idLine: Int = 0
    @objc dynamic var idEmissor: Int = 0
    @objc dynamic var name: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idLine <- map["idLinhaProdata"]
        idEmissor <- map["idEmissor"]
        name <- map["nome"]
    }
}
