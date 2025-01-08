//
//  RequestParking.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 01/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestParking: BasePojo {
    
    static let REQUEST_COMPRA = 1
    static let REQUEST_ATIVACAO = 2
    static let REQUEST_COMPRA_ATIVACAO = 3
    
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var area: String = ""
    @objc dynamic var setor: String = ""
    @objc dynamic var face: String = ""
    var opType: Int?
    @objc dynamic var plate: String = ""
    @objc dynamic var cadAmount: Int = 0
    @objc dynamic var time: Int = 0
    @objc dynamic var check: Int = 0
    @objc dynamic var scheduleDate: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        area <- map["area"]
        setor <- map["setor"]
        face <- map["face"]
        opType <- map["tipo_operacao"]
        plate <- map["Placa"]
        cadAmount <- map["QtdeCad"]
        time <- map["Tempo"]
        check <- map["Check"]
        scheduleDate <- map["Data_Agendada"]
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
        let bodyString = "{\"cod_ativacao\":\"\(self.area)\",\"id_cadastro\":\(self.area)}"
        return bodyString
    }
}
