//
//  OperatorValuesResponse.swift
//  MyQiwi
//
//  Created by Ailton on 18/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class OperatorValuesResponse : BasePojo {
    
    var values: [OperatorValue] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        values <- map["valores"]
    }
}
