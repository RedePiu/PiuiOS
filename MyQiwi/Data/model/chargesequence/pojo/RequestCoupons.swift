//
//  RequestCoupons.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 17/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestCoupons : BasePojo {
    
    @objc dynamic var code: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        code <- map["cod_cupom"]
    }
    
    convenience init(code: String) {
        self.init()
        
        self.code = code
    }
}
