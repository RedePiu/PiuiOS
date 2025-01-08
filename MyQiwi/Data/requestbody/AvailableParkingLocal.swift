//
//  AvailableParkingLocal.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class AvailableParkingLocal : BasePojo {
    
    @objc dynamic var latitude : Double = 0
    @objc dynamic var longitude : Double = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
    
    convenience init(lat: Double, long: Double) {
        self.init()
        
        self.latitude = lat
        self.longitude = long
    }
}
