//
//  LoginBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class LoginBody: BasePojo {

    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var password: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        phoneNumber <- map["num_celular"]
        password <- map["senha"]
    }
    
    convenience init(phoneNumber: String, password: String) {
        self.init()
        
        self.phoneNumber = phoneNumber
        self.password = password
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    //{"cod_ativacao":"342245","id_cadastro":9637}
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"num_celular\":\"\(self.phoneNumber)\",\"senha\":\"\(self.password)\"}"
        return bodyString
    }
}
