//
//  ParkingDeleteVehicleRequest.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class ParkingDeleteVehicleRequest : BasePojo {
    
    @objc dynamic var plate: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        plate <- map["placa"]
    }
    
    convenience init(plate: String) {
        self.init()
        
        self.plate = plate
    }
}
