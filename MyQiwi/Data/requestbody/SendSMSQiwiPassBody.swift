//
//  SendSMSQiwiPassBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 28/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class SendSMSQiwiPassBody : BasePojo {
    
    @objc dynamic var phone: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(phone: String) {
        self.init()
        
        self.phone = phone
    }
    
    override func mapping(map: Map) {
        phone <- map["telefone"]
    }
}
