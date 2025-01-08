//
//  Seat.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class Seat: BasePojo {
    
    var name: String = ""
    var isAvailable: String = ""
    var posX: Int = 0
    var posY: Int = 0
    var posZ: String = ""
    var coin: String = ""
    var price: Int = 0
    
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
