//
//  MetrocardProductsResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class MetrocardProductsResponse : BasePojo {
    
    @objc dynamic var userId : Int = 0
    @objc dynamic var product: MetrocardProduct? = MetrocardProduct()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        userId <- map["idComprador"]
        product <- map["produto"]
    }
}
