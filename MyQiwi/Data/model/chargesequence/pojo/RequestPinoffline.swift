//
//  RequestPinoffline.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestPinoffline: BasePojo {
 
    @objc dynamic var id: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["id_pinoffline"]
    }
    
    convenience init(id: Int) {
        self.init()
        
        self.id = id
    }
}
