//
//  OrderProBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class OrderProBody: BasePojo {
    
    @objc dynamic var fromDate : String = ""
    @objc dynamic var toDate : String = ""
    @objc dynamic var type: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        fromDate <- map["data_inicio"]
        toDate <- map["data_fim"]
        type <- map["tipo_extrato"]
    }
    
    convenience init(fromDate: String, toDate: String, type: Int) {
        self.init()
        
        self.fromDate = fromDate
        self.toDate = toDate
        self.type = type
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        return "{\"data_inicio\":\"\(self.fromDate)\",\"data_fim\":\"\(self.toDate)\",\"tipo_extrato\":\(self.type)}"
    }
}
