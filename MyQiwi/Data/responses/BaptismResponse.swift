//
//  BaptismResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class BaptismResponse: BasePojo {

    @objc dynamic var seq: String = "-1"
    @objc dynamic var b: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        seq <- map["sequencial"]
        b <- map["b"]
    }
}
