//
//  RequestRVSpotify.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 15/05/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestRVSpotify: BasePojo {
    
    @objc dynamic var cdProduct: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cdProduct <- map["cd_produto"]
    }
    
    convenience init(cdProduct: Int) {
        self.init()
        
        self.cdProduct = cdProduct
    }
}
