//
//  ClickbusSeatRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickbusSeatRequest : BasePojo {
    
    @objc dynamic var passengerDocument : String = ""
    @objc dynamic var passengerDocumentType : String = ""
    @objc dynamic var passengerFirstName : String = ""
    @objc dynamic var passengerGender : String = ""
    @objc dynamic var passengerLastName : String = ""
    @objc dynamic var seatId : String = ""
    @objc dynamic var tripId : String = ""
    @objc dynamic var tripType : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        passengerDocument <- map["PassengerDocument"]
        passengerDocumentType <- map["PassengerDocumentType"]
        passengerFirstName <- map["PassengerFirstName"]
        passengerGender <- map["PassengerGender"]
        passengerLastName <- map["PassengerLastName"]
        seatId <- map["SeatId"]
        tripId <- map["TripId"]
        tripType <- map["TripType"]
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
    //{"PassengerDocument","PassengerDocumentType","PassengerFirstName","PassengerGender","PassengerLastName","SeatId","TripId","TripType"})
        
        // Extract optional
        let bodyString = "{\"PassengerDocument\":\"\(self.passengerDocument)\",\"PassengerDocumentType\":\"\(self.passengerDocumentType)\",\"PassengerFirstName\":\"\(self.passengerFirstName)\",\"PassengerGender\":\"\(self.passengerGender)\",\"PassengerLastName\":\"\(self.passengerLastName)\",\"SeatId\":\"\(self.seatId)\",\"TripId\":\"\(self.tripId)\",\"TripType\":\(self.tripType)}"
        return bodyString
    }
}
