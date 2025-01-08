//
//  TransportCardCittaMobiBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 26/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportCardCittaMobiBody: BasePojo {
    
    @objc dynamic var idCity: Int = 1
    @objc dynamic var cardNumber: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(cardNumber: Int) {
        self.init()
        
        self.cardNumber = String(cardNumber)
    }
    
    override func mapping(map: Map) {
        idCity <- map["IdCidade"]
        cardNumber <- map["NumeroLogicoCartao"]
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
        let bodyString = "{\"IdCidade\":\(self.idCity),\"NumeroLogicoCartao\":\"\(self.cardNumber)\"}"
        return bodyString
    }
}
