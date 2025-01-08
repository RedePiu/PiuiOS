//
//  MetrocardUserBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 28/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class MetrocardUserBody : BasePojo {
    
    @objc dynamic var cpf: String = ""
    @objc dynamic var card: String = ""
    @objc dynamic var prvid: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cpf <- map["Cpf"]
        card <- map["Cartao"]
        prvid <- map["prvID"]
    }
    
    convenience init(cpf: String, card: String, prvid: Int) {
        self.init()
        self.cpf = cpf
        self.card = card
        self.prvid = prvid
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"Cpf\":\"\(self.cpf)\",\"Cartao\":\"\(self.card)\",\"prvID\":\(self.prvid)}"
        return bodyString
    }
}
