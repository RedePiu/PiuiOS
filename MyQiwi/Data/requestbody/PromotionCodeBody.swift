//
//  PromotionCodeBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class PromotionCodeBody: BasePojo {
    
    @objc dynamic var code: String = ""
    @objc dynamic var phone: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        code <- map["codigo"]
        phone <- map["numero"]
    }
    
    convenience init(code: String, phone: String) {
        self.init()
        
        self.code = code
        self.phone = phone
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    //{"numero":"11988447064","codigo":"QQ"}
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"numero\":\"\(self.phone)\",\"codigo\":\"\(self.code)\"}"
        return bodyString
    }
}
