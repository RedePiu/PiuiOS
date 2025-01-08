//
//  TelesenaProductsBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class TelesenaProductsBody: BasePojo {
    
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
        let bodyString = "{\"prvID\":\(self.prvid)}"
        return bodyString
    }
}
