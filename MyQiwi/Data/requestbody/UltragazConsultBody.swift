//
//  UltragazConsultBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 18/05/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class UltragazConsultBody: BasePojo {
    
    @objc dynamic var latitude: String = ""
    @objc dynamic var longitude: String =  ""
   
    required convenience init?(map: Map) {
        self.init()
    }
   
    override func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
   
    convenience init(latitude: Double, longitude: Double) {
        self.init()
       
        self.latitude = String(latitude)
        self.longitude = String(longitude)
    }
    
    convenience init(latitude: String, longitude: String) {
        self.init()
       
        self.latitude = latitude
        self.longitude = longitude
    }
   
    func generateJsonBody() -> Data {
       
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
       
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
   
    func generateJsonBodyAsString() -> String {
       
        ////{"body":{"cpf":"43497458821","num_celular":"11988447064","id_usuario":-1}
       
        // Extract optional
        //let bodyString = "{\"latitude\":\(self.latitude),\"longitude\":\(self.longitude)}"
        let bodyString = "{\"latitude\":\"\(self.latitude)\",\"longitude\":\"\(self.longitude)\"}"
        return bodyString
    }
}
