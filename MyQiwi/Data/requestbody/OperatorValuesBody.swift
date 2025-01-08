//
//  OperatorValuesBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class OperatorValuesBody : BasePojo {
    
    @objc dynamic var operatorId : Int = 0
    @objc dynamic var ddd : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        operatorId <- map["id_operadora"]
        ddd <- map["ddd"]
    }
    
    convenience init(operatorId: Int, ddd: String) {
        self.init()
        
        self.operatorId = operatorId
        self.ddd = ddd
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
//    func generateJsonBodyAsString() -> String {
//
//        // Extract optional
//        return "{\"ddd\":" + self.ddd + ",\"id_operadora\":" + self.operatorId + "}"
//    }
    
    func generateJsonBodyAsString() -> String {
        return "{\"ddd\":\"\(self.ddd)\",\"id_operadora\":\(self.operatorId)}"
    }
}
