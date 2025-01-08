//
//  ChangeQiwiPassBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 28/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ChangeQiwiPassBody : BasePojo {
    
    @objc dynamic var cpf: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var returnedPass: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(cpf: String, code: String, newPass: String) {
        self.init()
        
        self.cpf = cpf
        self.code = code
        self.returnedPass = newPass
        self.phone = UserRN.getLoggedUser().cel
    }
    
    override func mapping(map: Map) {
        cpf <- map["cpf"]
        code <- map["cod_ativacao"]
        phone <- map["telefone"]
        returnedPass <- map["senha"]
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
        let bodyString = "{\"cod_ativacao\":\"\(self.code)\",\"cpf\":\"\(self.cpf)\",\"senha\":\"\(self.returnedPass)\",\"telefone\":\"\(self.phone)\"}"
        return bodyString
    }
}
