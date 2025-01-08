//
//  RegisterResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RegisterResponse: BasePojo {

    @objc dynamic var registerId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        registerId <- map["id_Cadastro"]
    }
}
