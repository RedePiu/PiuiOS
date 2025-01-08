//
//  GetTransactionNewBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class GetTransactionNewBody: BasePojo {
    
    @objc dynamic var transitionId: Int = 0
    @objc dynamic var date: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(transitionId: Int, date: String) {
        self.init()
        
        self.transitionId = transitionId
        self.date = date
    }
    
    override func mapping(map: Map) {
        transitionId <- map["id_transacao"]
        date <- map["data_transacao"]
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
        let bodyString = "{\"id_transacao\":\(self.transitionId),\"data_transacao\":\"\(self.date)\"}"
        return bodyString
    }
}
