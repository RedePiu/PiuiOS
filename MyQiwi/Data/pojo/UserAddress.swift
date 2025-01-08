//
//  UserAddress.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class UserAddress: BasePojo {

    @objc dynamic var cep: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var street: String = ""
    @objc dynamic var streetNumber: Int = 0
    @objc dynamic var complement: String = ""
    
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
