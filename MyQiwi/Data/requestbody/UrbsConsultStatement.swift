//
//  UrbsConsultStatement.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class UrbsConsultStatement : BasePojo {
    
    @objc dynamic var cardNumber: String = ""
    @objc dynamic var initialDate: String = ""
    @objc dynamic var finalDate: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cardNumber <- map["id_cartao"]
        initialDate <- map["data_inicial"]
        finalDate <- map["data_final"]
    }
    
    convenience init(cardNumber: String, initialDate: String, finalDate: String) {
        self.init()
        
        self.cardNumber = cardNumber
        self.initialDate = initialDate
        self.finalDate = finalDate
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
        let bodyString = "{\"id_cartao\":\"\(self.cardNumber)\",\"data_inicial\":\"\(self.initialDate)\",\"data_final\":\"\(self.finalDate)\"}"
        return bodyString
    }
}
