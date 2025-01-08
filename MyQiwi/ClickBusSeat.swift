//
//  ClickBusSeat.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 12/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickBusSeat : BasePojo {
  
    @objc dynamic var seatName: String = ""
    @objc dynamic var passenger: PassengerClickBus? = PassengerClickBus()
    @objc dynamic var price: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        seatName <- map["seatName"]
        passenger <- map["PassengerClickBus"]
        price <- map["price"]
    }
    
    convenience init(name: String, price: Int, passenger: PassengerClickBus?) {
        self.init()
        self.seatName = name
        self.price = price
        self.passenger = passenger
    }
    
    convenience init(name: String, price: Int) {
        self.init()
        self.seatName = name
        self.price = price
    }
}
