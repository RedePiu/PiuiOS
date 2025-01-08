//
//  DividaCaixaComplementBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 23/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DividaCaixaComplementBody: BasePojo {
    
    @objc dynamic var dividaId: Int = 0
    @objc dynamic var complement: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(dividaId: Int, complement: String) {
        self.init()
        
        self.dividaId = dividaId
        self.complement = complement
    }
    
    override func mapping(map: Map) {
        dividaId <- map["Id_Divida"]
        complement <- map["Complemento"]
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
        //let bodyString = "{\"complemento\":\(self.complement),\"id_pedido\":\"\(self.orderId)\"}"
        let bodyString = "{\"Id_Divida\":\(self.dividaId),\"Complemento\":\"\(self.complement)\"}"
        return bodyString
    }
}

