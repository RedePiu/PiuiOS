//
//  Seat.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class SeatBody : BasePojo {
    
    @objc dynamic var seatId: Int = 0
    @objc dynamic var passengerName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var document: String = ""
    @objc dynamic var documentType: String = ""
    @objc dynamic var age: String = ""
    @objc dynamic var tripType: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        seatId <- map["assentoId"]
        passengerName <- map["NomePasageiro"]
        lastName <- map["Sobrenome"]
        document <- map["Documento"]
        documentType <- map["TipoDocumento"]
        age <- map["Idade"]
        tripType <- map["TipoViagem"]
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        // Extract optional
        let bodyString = "{\"assentoId\":\(self.seatId),\"NomePasageiro\":\"\(self.passengerName)\",\"Sobrenome\":\"\(self.lastName)\",\"Documento\":\"\(self.document)\",\"TipoDocumento\":\"\(self.documentType)\",\"Idade\":\"\(self.age)\",\"TipoViagem\":\(self.tripType)}"
        return bodyString
    }
}
