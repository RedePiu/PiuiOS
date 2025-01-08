//
//  SendPasswordSMSResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class SendPasswordSMSResponse: BasePojo {
    
    @objc dynamic var userId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        userId <- map["id_usuario"]
    }
}
