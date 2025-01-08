//
//  ClickbusTripDetailResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickbusTripDetailResponse : BasePojo {
    
    @objc dynamic var name : String = ""
    @objc dynamic var available : String = ""
    @objc dynamic var x : String = ""
    @objc dynamic var y : String = ""
    @objc dynamic var z : String = ""
    @objc dynamic var currency : String = ""
    @objc dynamic var price : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        name <- map["SeatId"]
        available <- map["SeatAvailable"]
        x <- map["SeatPosX"]
        y <- map["SeatPosY"]
        z <- map["SeatPosZ"]
        currency <- map["Currency"]
        price <- map["Price"]
    }
}
