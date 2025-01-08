//
//  OrderProContainer.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class OrderProContainer : BasePojo {
    
    @objc dynamic var date: String = ""
    var items: [OrderPro] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        date <- map["data"]
        items <- map["transacoes"]
    }
    
    convenience init(date: String, items: [OrderPro]) {
        self.init()
        
        self.date = date
        self.items = items
    }
}
