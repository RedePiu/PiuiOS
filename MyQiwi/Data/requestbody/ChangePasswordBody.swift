//
//  ChangePasswordBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class ChangePasswordBody : BasePojo {
    
    @objc dynamic var userId : Int = 0
    @objc dynamic var password : String = ""
    @objc dynamic var activationCode : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        userId <- map["id_usuario"]
        password <- map["senha"]
        activationCode <- map["cod_ativacao"]
    }
    
    convenience init(userId: Int, password: String, activationCode: String) {
        self.init()
        
        self.userId = userId
        self.password = password
        self.activationCode = activationCode
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        //{"body":{"cod_ativacao":"647916","senha":"48fd4ca5522d6328ed6a2493962275a7eb1fc972670140e1cea414fc2267054e","id_usuario":2}
        
        // Extract optional
        let bodyString = "{\"cod_ativacao\":\"\(self.activationCode)\",\"senha\":\"\(self.password)\",\"id_usuario\":\(self.userId)}"
        return bodyString
    }
}
