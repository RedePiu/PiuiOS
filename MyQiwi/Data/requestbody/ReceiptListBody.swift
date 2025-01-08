//
//  ReceiptListBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ReceiptListBody: BasePojo {
    
    @objc dynamic var fromDate : String = ""
    @objc dynamic var toDate : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        fromDate <- map["data_inicio"]
        toDate <- map["data_fim"]
    }
    
    convenience init(fromDate: String, toDate: String) {
        self.init()
        
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        return "{\"dataFim\":\"\(self.toDate)\",\"dataIni\":\"\(self.fromDate)\"}"
    }
}
