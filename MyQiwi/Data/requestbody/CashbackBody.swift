
//
//  CashbackBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 12/05/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class CashbackBody: BasePojo {
    
    @objc dynamic var orderId: Int = 0
    
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
