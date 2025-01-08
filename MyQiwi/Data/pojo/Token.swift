//
//  Token.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class Token: BasePojo {

    @objc dynamic var tokenId: Int = 0
    @objc dynamic var cvv: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        tokenId <- map["id_token"]
        cvv <- map["codSeguranca"]
    }
    
    convenience init(tokenId: Int) {
        self.init()
        
        self.tokenId = tokenId
    }
}
