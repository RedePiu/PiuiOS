//
//  ValidateCreditedValueBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 08/10/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class ValidateCreditedValueBody: BasePojo {
    
    @objc dynamic var cardNumber: String = ""
    @objc dynamic var value: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cardNumber <- map["numCartao"]
        value <- map["valor"]
    }
    
    convenience init(cardNumber: String, value: Int) {
        self.init()
        
        self.cardNumber = cardNumber
        self.value = value
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
        let bodyString = "{\"numCartao\":\"\(self.cardNumber)\",\"valor\":\(self.value)}"
        return bodyString
    }
}
