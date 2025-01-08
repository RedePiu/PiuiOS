//
//  DrTerapiaConsultValuesBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 10/07/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DrTerapiaConsultValuesBody: BasePojo {
    
    @objc dynamic var prvid: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        prvid <- map["prvID"]
    }
    
    convenience init(prvid: Int) {
        self.init()
        
        self.prvid = prvid
    }
    
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"doutorterapia\":{\"prvID\":\(self.prvid)}}"
        return bodyString
    }
}
