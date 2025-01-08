//
//  SendPasswordSMSBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class SendPasswordSMSBody : BasePojo {
    
    @objc dynamic var cpf : String = ""
    @objc dynamic var phone : String = ""
    @objc dynamic var userId : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cpf <- map["id_cadastro"]
        phone <- map["num_celular"]
        userId <- map["id_usuario"]
    }
    
    convenience init(cpf: String, phone: String, userId: Int) {
        self.init()
        
        self.cpf = cpf
        self.phone = phone
        self.userId = userId
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        ////{"body":{"cpf":"43497458821","num_celular":"11988447064","id_usuario":-1}
 
        // Extract optional
        let bodyString = "{\"cpf\":\"\(self.cpf)\",\"num_celular\":\"\(self.phone)\",\"id_usuario\":\(self.userId)}"
        return bodyString
    }
}
