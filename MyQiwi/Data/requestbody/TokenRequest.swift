//
//  TokenRequest.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class TokenRequest : BasePojo {

    @objc dynamic var token: String = ""

    required convenience init?(map: Map) {
        self.init()
    }

    override func mapping(map: Map) {
        token <- map["token"]
    }

    convenience init(token: String) {
        self.init()

        self.token = token
    }
}
