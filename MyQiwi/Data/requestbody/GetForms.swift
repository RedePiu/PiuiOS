//
//  GetForms.swift
//  MyQiwi
//
//  Created by Daniel Catini on 18/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class GetForms: BasePojo {
    
    @objc dynamic var Cpf: String = ""
    @objc dynamic var idEmissor: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        Cpf <- map["cpf"]
        idEmissor <- map["id_emissor"]
    }
    
    convenience init(idEmissor: Int, cpf: String) {
        self.init()
        
        self.Cpf = cpf
        self.idEmissor = idEmissor
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
        let bodyString = "{\"cpf\":\"\(self.Cpf)\",\"id_emissor\":\(self.idEmissor)}"
        return bodyString
    }
}

