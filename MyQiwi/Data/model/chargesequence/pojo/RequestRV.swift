//
//  RequestRV.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestRV: BasePojo {
    
    @objc dynamic var cdSubscriber: String = ""
    @objc dynamic var cdProduct: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cdSubscriber <- map["cd_assinante"]
        cdProduct <- map["cd_produto"]
    }
    
    convenience init(cdProduct: Int) {
        self.init()
        
        self.cdProduct = cdProduct
    }
}
