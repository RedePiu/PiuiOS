//
//  DividaListBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DividaListBody : BasePojo {
    
    @objc dynamic var dateFrom : String = ""
    @objc dynamic var dateTo : String = ""
    @objc dynamic var status : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        dateFrom <- map["data_inicio"]
        dateTo <- map["data_fim"]
        status <- map["status"]
    }
    
    convenience init(dateFrom: String, dateTo: String, status: Int) {
        self.init()
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.status = status
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"data_inicio\":\"\(self.dateFrom)\",\"data_fim\":\"\(self.dateTo)\",\"status\":\(self.status)}"
        return bodyString
    }
}

