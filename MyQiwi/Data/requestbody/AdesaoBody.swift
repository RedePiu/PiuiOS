//
//  AdesaoBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class AdesaoBody : BasePojo {
    
    static let ADESAO_DIGITAL = 1
    
    @objc dynamic var type: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        type <- map["tipoAdesao"]
    }
    
    convenience init?(type: Int) {
        self.init()
        
        self.type = type
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
        let bodyString = ""//{\"cod_ativacao\":\"\(self.car)\",\"id_cadastro\":\(self.car)}"
        return bodyString
    }
}

