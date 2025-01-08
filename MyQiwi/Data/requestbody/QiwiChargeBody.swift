//
//  QiwiChargeRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class QiwiChargeBody : BasePojo {
    
    @objc dynamic var pass: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        //pass <- map["senha"]
    }
    
    convenience init(pass: String) {
        self.init()
        self.pass = pass
    }
}
