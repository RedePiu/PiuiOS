//
//  LoginBody.swift
//  MyQiwi
//
//  Created by Daniel Catini on 12/09/23.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class DeleteBody: BasePojo {

    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var cpf: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        phoneNumber <- map["num_celular"]
        password <- map["senha"]
        cpf <- map["cpf"]
    }
    
    convenience init(phoneNumber: String, password: String, cpf: String) {
        self.init()
        
        self.phoneNumber = phoneNumber
        self.password = password
        self.cpf = cpf
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    //{"cod_ativacao":"342245","id_cadastro":9637}
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"num_celular\":\"\(self.phoneNumber)\",\"senha\":\"\(self.password)\",\"cpf\":\"\(self.cpf)\"}"
        return bodyString
    }
}

