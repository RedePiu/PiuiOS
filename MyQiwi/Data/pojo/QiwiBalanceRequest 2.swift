//
//  QiwiBalanceRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class QiwiBalanceRequest : BasePojo {

    var pass: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        pass <- map["senha"]
    }
    
    convenience init(pass: String) {
        self.init()
        self.pass = pass
    }
}
