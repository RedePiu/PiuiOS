//
//  Vehicle.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 01/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class Vehicle: BasePojo {
    
    @objc dynamic var plate: String = ""
    @objc dynamic var car: String = ""
    @objc dynamic var type: Int = 0
    @objc dynamic var parkedDate: String = ""
    @objc dynamic var time: Int = 0
    @objc dynamic var cads: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        plate <- map["placa"]
        car <- map["nome"]
        type <- map["tipo"]
        parkedDate <- map["dt_ativacao"]
        time <- map["tempo"]
        cads <- map["cads"]
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    //{"cod_ativacao":"342245","id_cadastro":9637}
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"cod_ativacao\":\"\(self.car)\",\"id_cadastro\":\(self.car)}"
        return bodyString
    }
}
