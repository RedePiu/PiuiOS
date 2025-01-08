//
//  CoordinateCET.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CoordinateCET: BasePojo {
    
    var id: Int = 0
    var lat: Double = 0
    var long: Double = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["Id_Coordenada_CET"]
        lat <- map["Latitude"]
        long <- map["Longitude"]
    }
}
