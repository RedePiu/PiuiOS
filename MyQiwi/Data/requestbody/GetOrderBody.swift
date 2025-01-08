//
//  GetOrderBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class GetOrderBody : BasePojo {
    
    @objc dynamic var orderId : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        orderId <- map["id_pedido"]
    }
    
    convenience init(orderId: Int) {
        self.init()
        
        self.orderId = orderId
    }
}
