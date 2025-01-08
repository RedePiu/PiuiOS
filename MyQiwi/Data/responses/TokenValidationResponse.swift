//
//  TokenValidationResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/11/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class TokenValidationResponse : BasePojo {
    
    @objc dynamic var status = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        status <- map["status_token"]
    }
}
