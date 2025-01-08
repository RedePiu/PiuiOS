//
//  EmptyObject.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class EmptyObject: BasePojo {
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
    }
}
