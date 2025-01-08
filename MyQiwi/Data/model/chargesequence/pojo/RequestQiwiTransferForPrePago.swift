//
//  RequestQiwiTransferForPrePago.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 16/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestQiwiTransferForPrePago : BasePojo {
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
    }
}
