//
//  ClickbusTripDetailRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickbusTripDetailRequest : BasePojo {
    
    @objc dynamic var sessionId : Int = 0
    @objc dynamic var tripType : Int = 0
    @objc dynamic var scheduleId : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        sessionId <- map["sessionId"]
        tripType <- map["TipoViagem"]
        scheduleId <- map["ScheduleId"]
    }
    
    convenience init(sessionId: Int, tripType: Int, scheduleId: String) {
        self.init()
        
        self.sessionId = sessionId
        self.tripType = tripType
        self.scheduleId = scheduleId
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        //{"sessionId","TipoViagem","ScheduleId"})
        
        // Extract optional
        let bodyString = "{\"sessionId\":\(self.sessionId),\"TipoViagem\":\(self.tripType),\"ScheduleId\":\"\(self.scheduleId)\"}"
        return bodyString
    }
}
