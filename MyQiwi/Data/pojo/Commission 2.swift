//
//  Commision.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class Commission : BasePojo {
    
    var name: String = ""
    var tax: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(_ name: String,_ tax: String) {
        self.init()
        
        self.name = name
        self.tax = tax
    }
    
    override func mapping(map: Map) {
        name <- map["Produto"]
        tax <- map["Comissao"]
    }
}
