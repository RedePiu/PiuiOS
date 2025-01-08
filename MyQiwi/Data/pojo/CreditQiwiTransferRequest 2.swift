//
//  CreditQiwiTransferRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CreditQiwiTransferRequest : BasePojo {
    
    var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var receiptDesc: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        phone <- map["dispositivo"]
        receiptDesc <- map["descricao"]
    }
}
