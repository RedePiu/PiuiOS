//
//  DividaReceipt.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 20/07/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DividaReceipt : BasePojo {
    
    var code: String = ""
    var value: Double = 0
    var attaches: [Anexo] = [Anexo]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(code: String, value: Double, attaches: [Anexo]) {
        self.init()
        
        self.code = code
        self.value = value
        self.attaches = attaches
    }
    
    override func mapping(map: Map) {
        code <- map["codigo"]
        value <- map["valor"]
        attaches <- map["anexos_divida"]
    }
}
