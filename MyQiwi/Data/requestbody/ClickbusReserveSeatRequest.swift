//
//  ClickbusReserveSeatRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickbusReserveSeatRequest : BasePojo {
    
    @objc dynamic var sessionId : Int = 0
    var seats : [ClickbusSeatRequest] = [ClickbusSeatRequest]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        sessionId <- map["sessionId"]
        seats <- map["Assentos"]
    }
    
    convenience init(sessionId: Int, seats: [ClickbusSeatRequest]) {
        self.init()
        
        self.sessionId = sessionId
        self.seats = seats
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateSeatsArrayJson() -> String {
        var json = "["
        
        for i in 0..<self.seats.count {
            json += self.seats[i].generateJsonBodyAsString()
            
            if i < self.seats.count - 1 {
                json += ","
            }
        }
        
        json += "]"
        return json
    }
    
    func generateJsonBodyAsString() -> String {
        
        //{"body":{"cod_ativacao":"647916","senha":"48fd4ca5522d6328ed6a2493962275a7eb1fc972670140e1cea414fc2267054e","id_usuario":2}
        
        // Extract optional
        let bodyString = "{\"sessionId\":\(self.sessionId),\"Assentos\":\(self.generateSeatsArrayJson())}"
        return bodyString
    }
}
