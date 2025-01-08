//
//  RequestCepConsult.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestCepConsult : BasePojo {
    
    @objc dynamic var cep: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cep <- map["cep"]
    }
    
    convenience init(cep: String) {
        self.init()
        
        self.cep = cep
    }
}
