//
//  ClickbusScheduleResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickbusScheduleResponse : BasePojo {
  
    @objc dynamic var sessionId: Int = 0
    @objc dynamic var scheduleId: String = ""
    @objc dynamic var from: String = ""
    @objc dynamic var to: String = ""
    @objc dynamic var tripId: String = ""
    @objc dynamic var originCity: String = ""
    @objc dynamic var originState: String = ""
    @objc dynamic var originStation: String = ""
    @objc dynamic var destinyCity: String = ""
    @objc dynamic var destinyState: String = ""
    @objc dynamic var destinyStation: String = ""
    @objc dynamic var dateDeparture: String = ""
    @objc dynamic var timeDeparture: String = ""
    @objc dynamic var timeZonedeparture: String = ""
    @objc dynamic var dateArrival: String = ""
    @objc dynamic var timeArrival: String = ""
    @objc dynamic var timeZoneArrival: String = ""
    @objc dynamic var busCompany: String = ""
    @objc dynamic var price: Int = 0
    @objc dynamic var logo: String = ""
    @objc dynamic var serviceClass: String = ""
    @objc dynamic var time: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        sessionId <- map["Id_Teminal_Mobile_Session"]
        scheduleId <- map["ScheduleId"]
        from <- map["From"]
        to <- map["To"]
        tripId <- map["Trip_Id"]
        originCity <- map["CidadeOrigem"]
        originState <- map["EstadoOrigem"]
        originStation <- map["EstacaoOrigem"]
        destinyCity <- map["CidadeDestino"]
        destinyState <- map["EstadoDestino"]
        destinyStation <- map["EstacaoDestino"]
        dateDeparture <- map["DataPartida"]
        timeDeparture <- map["TimePartida"]
        timeZonedeparture <- map["TimeZonePartida"]
        dateArrival <- map["DataChegada"]
        timeArrival <- map["TimeChegada"]
        timeZoneArrival <- map["TimeZoneChegada"]
        busCompany <- map["BusCompany"]
        price <- map["Preco"]
        logo <- map["logo"]
        serviceClass <- map["ServiceClass"]
        time <- map["Time"]
    }
}
