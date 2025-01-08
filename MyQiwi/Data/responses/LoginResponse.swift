
//
//  LoginResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class LoginResponse: BasePojo {

    @objc dynamic var userId: Int = 0
    @objc dynamic var t: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        userId <- map["id_Usuario"]
        t <- map["t"]
    }
}
