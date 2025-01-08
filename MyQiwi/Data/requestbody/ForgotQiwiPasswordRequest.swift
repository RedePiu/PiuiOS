//
//  ForgotQiwiPasswordRequest.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class ForgotQiwiPasswordRequest : BasePojo {
    
    @objc dynamic var cpf : String = ""
    @objc dynamic var phone : String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cpf <- map["cpf"]
        phone <- map["telefone"]
    }
    
    convenience init(cpf: String, phone: String) {
        self.init()
        
        self.cpf = cpf
        self.phone = phone
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    //{"cpf":"","telefone":""}
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"cpf\":\"\(self.cpf)\",\"telefone\":\"\(self.phone)\"}"
        return bodyString
    }
}
