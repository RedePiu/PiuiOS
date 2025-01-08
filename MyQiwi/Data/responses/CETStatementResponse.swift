//
//  CETStatementResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 06/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CETStatementResponse: BasePojo {
    
    @objc dynamic var date: String = ""
    var transactions: [CETStatement] = [CETStatement]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        date <- map["data"]
        transactions <- map["transacoes"]
    }
}
