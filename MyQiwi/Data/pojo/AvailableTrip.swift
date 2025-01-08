//
//  AvailableTrip.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class AvailableTrip : BasePojo {
    
    @objc dynamic var price: Int = 0
    var availableSeats: [SeatBody] = [SeatBody]()
    @objc dynamic var serviceCasse: String = ""
    @objc dynamic var busCompanyName: String = ""
    @objc dynamic var busCompanyLogo: String = ""
    @objc dynamic var originCity: String = ""
    @objc dynamic var originState: String = ""
    @objc dynamic var originCountry: String = ""
    @objc dynamic var departureDate: String = ""
    @objc dynamic var departureTime: String = ""
    @objc dynamic var timezone: String = ""
    @objc dynamic var arrivalCity: String = ""
    @objc dynamic var arrivalState: String = ""
    @objc dynamic var arrivalCountry: String = ""
    @objc dynamic var arrivalDate: String = ""
    @objc dynamic var arrivalTime: String = ""
    @objc dynamic var arrivalTimezone: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        price <- map["Preco"]
        availableSeats <- map["AssentosDisponiveis"]
        serviceCasse <- map["CasseServico"]
        busCompanyName <- map["NomeEmpresaOnibus"]
        busCompanyLogo <- map["LogoEmpresaOnibus"]
        originCity <- map["Cidadeorigem"]
        originState <- map["EstadoOrigem"]
        originState <- map["PaisdeOrigem"]
        departureDate <- map["DataPartida"]
        departureTime <- map["HoraPartida"]
        timezone <- map["FusoHorario"]
        arrivalCity <- map["CidadeChegada"]
        arrivalState <- map["EstadoChegada"]
        arrivalCountry <- map["PaisChegada"]
        arrivalDate <- map["DataChegada"]
        arrivalTime <- map["HorarioChegada"]
        arrivalTimezone <- map["FusoHorarioChegada"]
    }
}
