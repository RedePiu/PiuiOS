//
//  RequestDrterapia.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 09/07/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//


import ObjectMapper

class RequestDrTerapia : BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var desc: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["produto"]
        desc <- map["descricao"]
    }
    
    convenience init(id: Int, desc: String) {
        self.init()
        
        self.id = id
        self.desc = desc
    }
}
