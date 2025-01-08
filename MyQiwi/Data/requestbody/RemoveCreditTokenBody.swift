//
//  RemoveCreditTokenBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RemoveCreditTokenBody : BasePojo {
    
    @objc dynamic var tokenId : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        tokenId <- map["id_token"]
    }
    
    convenience init(tokenId: Int) {
        self.init()
        
        self.tokenId = tokenId
    }
}
