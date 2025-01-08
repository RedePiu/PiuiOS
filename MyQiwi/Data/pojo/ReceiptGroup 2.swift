//
//  ReceiptGroup.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 04/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ReceiptGroup : BasePojo {
    
    var date: String = ""
    var receipts: [Receipt] = [Receipt]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        date <- map["data"]
        receipts <- map["recibos"]
    }
}
