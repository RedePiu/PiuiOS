//
//  InsertOrUpdateBody.swift
//  MyQiwi
//
//  Created by Ailton on 22/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class InsertOrUpdateBody : BasePojo {
    
    var transportCard : TransportCard?
    var phoneContact : PhoneContact?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        transportCard <- map["bilhete"]
        phoneContact <- map["telefone"]
    }
    
    convenience init(transportCard: TransportCard) {
        self.init()
        
        self.transportCard = transportCard
    }
    
    convenience init(phoneContact: PhoneContact) {
        self.init()
        
        self.phoneContact = phoneContact
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        var bodyString = ""
        
        if self.transportCard != nil {
            return "{\"bilhete\":" + self.transportCard!.generateJsonBodyAsString() + "}"
        }
        
//        //{"telefone":{"appid":0,"ddd":"11","apelido":"Teste","numero":"988445570","operadora":"claro","id_agrupador_usuario":0}}
//        if self.phoneContact != nil {
//            return "{\"telefone\":" + self.phoneContact!}"
//        }
        
        return bodyString
    }
}
