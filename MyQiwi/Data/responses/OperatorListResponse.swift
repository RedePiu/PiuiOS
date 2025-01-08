//
//  OperatorListResponse.swift
//  MyQiwi
//
//  Created by Ailton on 13/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class OperatorListResponse : BasePojo {
    
    var operators : [Operator] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        operators <- map["operadoras"]
    }
}
