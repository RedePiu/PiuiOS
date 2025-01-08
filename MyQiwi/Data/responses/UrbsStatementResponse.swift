//
//  UrbsStatementResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class UrbsStatementResponse : BasePojo {
    
    var registries: [UrbsRegistry] = [UrbsRegistry]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        registries <- map["registros"]
    }
}
