//
//  CoordinateCET.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CoordinateCET: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var lat: Double = 0
    @objc dynamic var long: Double = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["Id_Coordenada_CET"]
        lat <- map["Latitude"]
        long <- map["Longitude"]
    }
}
