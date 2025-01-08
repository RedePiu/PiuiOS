//
//  GetOrderListBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class GetOrderListBody : BasePojo {
    
    @objc dynamic var startFrom : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        startFrom <- map["start_from"]
    }
    
    convenience init(startFrom: Int) {
        self.init()
        
        self.startFrom = startFrom
    }
}
