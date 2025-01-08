//
//  Seat.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class Seat: BasePojo {
    
    @objc dynamic var name: String = ""
    @objc dynamic var isAvailable: String = ""
    @objc dynamic var posX: Int = 0
    @objc dynamic var posY: Int = 0
    @objc dynamic var posZ: String = ""
    @objc dynamic var coin: String = ""
    @objc dynamic var price: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        name <- map["SeatId"]
        isAvailable <- map["SeatAvailable"]
        posX <- map["SeatPosX"]
        posY <- map["SeatPosY"]
        posZ <- map["SeatPosZ"]
        coin <- map["Currency"]
        price <- map["Price"]
    }
    
    convenience init(name: String) {
        self.init()
        
        self.name = name
    }
}
