//
//  QiwiBalanceResponse.swift
//  MyQiwi
//
//  Created by Ailton on 20/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class QiwiBalanceResponse: BasePojo {
    
    @objc dynamic var balance: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        balance <- map["saldo"]
    }
}
