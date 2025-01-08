//
//  RegisterActivationBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RegisterActivationBody : BasePojo {
    
    @objc dynamic var registerId: Int = 0
    @objc dynamic var activationCod: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        registerId <- map["id_cadastro"]
        activationCod <- map["cod_ativacao"]
    }
    
    convenience init(activationCod: String, registerId: Int) {
        self.init()
        
        self.activationCod = activationCod
        self.registerId = registerId
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
        let bodyString = "{\"cod_ativacao\":\"\(self.activationCod ?? "")\",\"id_cadastro\":\(self.registerId)}"
        return bodyString
    }
}
