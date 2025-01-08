//
//  ClickbusCancelReserveSeatRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickbusCancelReserveSeatRequest : BasePojo {
    
    @objc dynamic var codTerminal : String = ""
    @objc dynamic var seatId : String = ""
    @objc dynamic var sessionId : Int = 0
    @objc dynamic var tripType : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        codTerminal <- map["codTerminal"]
        seatId <- map["SeatId"]
        sessionId <- map["sessionId"]
        tripType <- map["TripType"]
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"codTerminal\":\"\(self.codTerminal)\",\"SeatId\":\"\(self.seatId)\",\"sessionId\":\"\(self.sessionId)\",\"TripType\":\(self.tripType)}"
        return bodyString
    }
}
