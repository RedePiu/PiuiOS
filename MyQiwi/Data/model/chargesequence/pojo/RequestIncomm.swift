//
//  RequestIncomm.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestIncomm: BasePojo {

    @objc dynamic var id: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["incomm_id"]
    }
    
    convenience init(id: Int) {
        self.init()
        
        self.id = id
    }
}
