//
//  EditCreditCardBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/05/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class EditCreditCardBody: BasePojo {

    @objc dynamic var cardNumber: String = ""
    @objc dynamic var nickname: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(cardNumber: String, nickname: String) {
        self.init()
        
        self.cardNumber = cardNumber
        self.nickname = nickname
    }
    
    override func mapping(map: Map) {
        cardNumber <- map["numero_cartao"]
        nickname <- map["apelido"]
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
        let bodyString = "{\"numero_cartao\":\"\(self.cardNumber)\",\"apelido\":\"\(self.nickname)\"}"
        return bodyString
    }
}

