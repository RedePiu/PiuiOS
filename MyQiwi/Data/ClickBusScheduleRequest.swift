//
//  ClickBusScheduleRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickBusScheduleRequest : BasePojo {

    @objc dynamic var from : String = ""
    @objc dynamic var to : String = ""
    @objc dynamic var date : String = ""
    @objc dynamic var idSession : Int = 0
    @objc dynamic var tripType: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        from <- map["Origem"]
        to <- map["Destino"]
        date <- map["DataViagem"]
        idSession <- map["idSession"]
        tripType <- map["tripType"]
    }
    
    convenience init(idSession: Int, from: String, to: String, Date: String) {
        self.init()
        
        self.from = from
        self.to = to
        self.date = Date
        self.idSession = idSession
    }
    
    convenience init(idSession: Int, from: String, to: String, Date: String, tripType: Int) {
        self.init()
        
        self.from = from
        self.to = to
        self.date = Date
        self.idSession = idSession
        self.tripType = tripType
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        //{"idSession","Origem","Destino","DataViagem"})
        
        // Extract optional
        let bodyString = "{\"idSession\":\(self.idSession),\"Origem\":\"\(self.from)\",\"Destino\":\"\(self.to)\",\"DataViagem\":\"\(self.date)\",\"tripType\":\(self.tripType)}"
        return bodyString
    }
}
