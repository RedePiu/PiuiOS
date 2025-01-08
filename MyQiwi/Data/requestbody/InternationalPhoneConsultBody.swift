//
//  InternationalPhoneConsult.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 01/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class InternationalPhoneConsultBody: BasePojo {
    
    @objc dynamic var phone: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(phone: String) {
        self.init()
        
        self.phone = phone
    }
    
    override func mapping(map: Map) {
        phone <- map["Telefone"]
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
        let bodyString = "{\"Telefone\":\"\(self.phone)\"}"
        return bodyString
    }
}

