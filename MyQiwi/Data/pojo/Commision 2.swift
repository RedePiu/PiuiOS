//
//  Commision.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class Commission : BasePojo {
    
    var cep: String = ""
    var state: String = ""
    var city: String = ""
    var street: String = ""
    var streetNumber: Int = 0
    var complement: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cep <- map["cep"]
        state <- map["state"]
        city <- map["city"]
        street <- map["street"]
        streetNumber <- map["streetNumber"]
        complement <- map["complement"]
    }
}
