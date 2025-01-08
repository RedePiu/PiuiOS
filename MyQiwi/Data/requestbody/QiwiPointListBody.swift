//
//  QiwiPointListBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/05/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class QiwiPointListBody: BasePojo {
    
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var raio: Int = 0
    @objc dynamic var isFirstConsult: Bool = false
    @objc dynamic var paymentType: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(latitude: Double, longitude: Double, raio: Int, isFirstConsult: Bool, paymentType: Int) {
        self.init()
        
        self.latitude = latitude
        self.longitude = longitude
        self.raio = raio
        self.isFirstConsult = isFirstConsult
        self.paymentType = paymentType
    }
    
    override func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        raio <- map["raio"]
        isFirstConsult <- map["primeira_consulta"]
        paymentType <- map["id_tipo_peca"]
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
        let bodyString = "{\"id_tipo_peca\":\(self.paymentType),\"latitude\":\(self.latitude),\"longitude\":\(self.longitude),\"raio\":\(self.raio),\"primeira_consulta\":\(self.isFirstConsult)}"
        return bodyString
    }
}
