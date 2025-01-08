//
//  RequestGetAllAvailableTrips.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class GetAllAvailableTripsBody : BasePojo {
    
    @objc dynamic var sessionId: Int = 0
    @objc dynamic var origin: String = ""
    @objc dynamic var destiny: String = ""
    @objc dynamic var tripDate: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        sessionId <- map["Idsessao"]
        origin <- map["Origem"]
        destiny <- map["destino"]
        tripDate <- map["DataPartida"]
    }
    
    convenience init(sessionId: Int, origin: String, destiny: String, tripDate: String) {
        self.init()
        
        self.sessionId = sessionId
        self.origin = origin
        self.destiny = destiny
        self.tripDate = tripDate
    }
    
    convenience init(origin: String, destiny: String, tripDate: String) {
        self.init()
        
        self.origin = origin
        self.destiny = destiny
        self.tripDate = tripDate
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        // Extract optional
        let bodyString = "{\"Idsessao\":\(self.sessionId),\"Origem\":\"\(self.origin)\",\"destino\":\"\(self.destiny)\",\"DataPartida\":\"\(self.tripDate)\"}"
        return bodyString
    }
}
