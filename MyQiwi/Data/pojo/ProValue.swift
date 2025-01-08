//
//  ProValue.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 21/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ProValue: BasePojo {

    @objc dynamic var name: String = ""
    @objc dynamic var prvid: Int = 0
    @objc dynamic var price: Double = 0
    @objc dynamic var commission: Double = 0
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(order: OrderPro) {
        self.init()
        
        self.name = order.product ?? ""
        self.prvid = order.prvid
        self.price = order.value
        self.commission = order.commission
    }
    
    convenience init(name: String, prvid: Int, price: Double, commission: Double) {
        self.init()
        
        self.name = name
        self.prvid = prvid
        self.price = price
        self.commission = commission
    }
    
    public override func mapping(map: Map) {
        name <- map["nome"]
        prvid <- map["PrvID"]
        price <- map["preco"]
        commission <- map["comissao"]
    }
    
    func addPrice(price: Double) {
        self.price = self.price + price
    }
    
    func addCommission(commission: Double) {
        self.commission = self.commission + commission
    }
}
