//
//  TransportProdataBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 05/11/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportProdataBody: BasePojo {
    
    @objc dynamic var prvid: Int = 0
    @objc dynamic var cardNumber: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        prvid <- map["id_Prv"]
        cardNumber <- map["numero_cartao"]
    }
    
    convenience init(prvid: Int) {
        self.init()
        
        self.prvid = prvid
    }
    
    convenience init(prvid: Int, cardNumber: Int) {
        self.init()
        
        self.prvid = prvid
        self.cardNumber = cardNumber
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"id_Prv\":\(self.prvid),\"numero_cartao\":\(self.cardNumber)}"
        return bodyString
    }
}
