//
//  MarkSeatBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class MarkSeatBody : BasePojo {
    
    @objc dynamic var sessionId: Int = 0
    @objc dynamic var listQtd: Int = 0
    var seats: [SeatBody] = [SeatBody]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        sessionId <- map["sessionId"]
        listQtd <- map["listQtd"]
        seats <- map["Assentos"]
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        // Extract optional
        var bodyString = "{\"sessionId\":\(self.sessionId),\"listQtd\":\(self.listQtd),\"Assentos\":["
        
        if !self.seats.isEmpty {
            for i in 0..<seats.count {
                bodyString += self.seats[i].generateJsonBodyAsString()
                
                if i < seats.count-1 {
                    bodyString += ","
                }
            }
        }
        bodyString += "]"
        
        return bodyString
    }
}
