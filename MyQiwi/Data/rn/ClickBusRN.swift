//
//  ClickBusRN.swift
//  MyQiwi
//
//  Created by Thyago on 09/09/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import ObjectMapper

class ClickBusRN: BaseRN {
    
    init() {
        super.init(delegate: nil)
    }
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    static func getPassangerDocumentList() -> [String] {
        return ["RG", "CPF", "CNH", "Passaporte"]
    }
    
    func savePassenger(passenger: PassengerClickBus) {
        
        let dao = PassengerClickBusDAO()
        dao.insert(with: passenger)
    }
    
    func removePassenger(passenger: PassengerClickBus) {
        
        let dao = PassengerClickBusDAO()
        dao.delete(with: passenger)
    }
    
    func removePassenger(document: String) {
        
        let dao = PassengerClickBusDAO()
        dao.deleteWithDocument(document: document)
    }
    
    func updatePassenger(passenger: PassengerClickBus) {
        
        let dao = PassengerClickBusDAO()
        dao.update(with: passenger)
    }
    
    func getPassengers() -> [PassengerClickBus] {
        var pass = [PassengerClickBus]()
        let originalPass = PassengerClickBusDAO().getAll()
        
        for p in originalPass {
            pass.append(PassengerClickBus(id: p.id, name: p.name, document: p.document, documentType: p.documentType, documentTypePosition: p.documentTypePosition))
        }
        
        return pass
    }
    
    static func setClickbusUpdateNeeded(needed: Bool) {
        UserDefaults.standard.set(needed, forKey: PrefsKeys.PREFS_CLICKBUS_UPDATE_NEEDED)
    }
    
    static func isUpdateNeeded() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_CLICKBUS_UPDATE_NEEDED)
    }
    
    static func setFileVersion(version: Int, fileName: String) {
        
        let currentVersion = UserDefaults.standard.integer(forKey: PrefsKeys.PREFS_CLICKBUS_FILE_VERSION)
        if currentVersion != version {
            UserDefaults.standard.set(version, forKey: PrefsKeys.PREFS_CLICKBUS_FILE_VERSION)
            UserDefaults.standard.set(fileName, forKey: PrefsKeys.PREFS_CLICKBUS_FILE_NAME)
            UserDefaults.standard.set(true, forKey: PrefsKeys.PREFS_CLICKBUS_UPDATE_NEEDED)
        }
    }
    
    static func getClickbusFileName() -> String {
        return UserDefaults.standard.string(forKey: PrefsKeys.PREFS_CLICKBUS_FILE_NAME) ?? ""
    }
    
    func getMainCities() -> [ClickBusCity] {
        var cityArray = [ClickBusCity]()
        
        cityArray.append(ClickBusCity(id: 1, slug: "sao-paulo-sp-todos", name: "Sao Paulo, SP - TODOS"))
        cityArray.append(ClickBusCity(id: 7627, slug: "rio-de-janeiro-rj-todos", name: "Rio de Janeiro, RJ - TODOS"))
        cityArray.append(ClickBusCity(id: 2373, slug: "belo-horizonte-mg", name: "Belo Horizonte, MG - Centro"))
        
        return cityArray
    }
    
    func getCities(name: String = "") -> [ClickBusCity] {

        let cities = ClickBusCityDAO().getAll().filter({$0.name.lowercased().prefix(name.count) == name.lowercased()})
        return cities
    }
    
    func hasCitiesInDB() -> Bool {
        let cities = ClickBusCityDAO().getAll()
        return !cities.isEmpty
    }
    
    func downloadCitiesFile() {
        AmazonRN(delegate: self).readFile(key: ClickBusRN.getClickbusFileName())
    }
    
    func getAllAvailableTrips(origin: String, destiny: String, tripDate: String) {
//
//        let body = GetAllAvailableTripsBody(origin: origin, destiny: destiny, tripDate: tripDate)
//
//        let serviceBody = updateJsonWithHeader(jsonBody: body.toJSONString() ?? "")
//        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetAllAvailableTrips, json: serviceBody)
//
//        callApi(request: request) { (response) in
//
//            //se removeu do server, removemos do banco
//            if response.sucess {
//
//            }
//
//            self.sendContact(fromClass: ClickBusRN.self, param: Param.Contact.CLICKBUS_TRIPS_AVAILABLE_RESPONSE,
//                             result: response.sucess, object: nil)
//        }
    }
    
    func getDataApi() {
        
    }
    
    func getClickBusSchedule(request: ClickBusScheduleRequest) {
        
        var trips = [ClickbusScheduleResponse]()
        
        // Create request
        let serviceBody = updateJsonWithHeader(jsonBody: request.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedScheduleConsult, json: serviceBody)
        
        callApiForList(ClickbusScheduleResponse.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                trips = (response.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: ClickBusRN.self, param: Param.Contact.CLICKBUS_SCHEDULE_RESPONSE,
                             result: response.sucess, object: trips as AnyObject)
        }
    }
    
    func getClickbusTripDetail(request: ClickbusTripDetailRequest) {
        
        var details = [Seat]()
        
        // Create request
        let serviceBody = updateJsonWithHeader(jsonBody: request.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTripDetails, json: serviceBody)
        
        callApiForList(Seat.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                details = (response.body?.data) ?? [Seat]()
                
                if !details.isEmpty {
                    details = self.sortSeats(seats: details)
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: ClickBusRN.self, param: Param.Contact.CLICKBUS_SEATS_AVAILABLE_RESPONSE,
                             result: response.sucess && !details.isEmpty, object: details as AnyObject)
        }
    }
    
    func sortSeats(seats: [Seat]) -> [Seat] {
        var busSeats = [Seat]()
        var matrix = [[Seat]](repeating: [Seat](repeating: Seat(), count: 5), count: 18)
        
        var x = 0
        var y = 0
        
        for i in 0..<seats.count {
            x = seats[i].posX
            y = seats[i].posY
            
            matrix[x][y] = seats[i]
        }
        
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                if !matrix[i][j].name.isEmpty {
                    busSeats.append(matrix[i][j])
                } else {
                    busSeats.append(Seat(name: "@"))
                }
            }
        }
        
        return busSeats
    }
    
    func convertSeatToSeatRequest(seats: [Seat]) -> [ClickBusSeat] {
        var busSeats = [ClickBusSeat]()
        
        for seat in seats {
            busSeats.append(ClickBusSeat(name: seat.name, price: seat.price))
        }
        
        return busSeats
    }
    
    func reserveSeat(request: ClickbusReserveSeatRequest) {
        
        // Create request
        let serviceBody = updateJsonWithHeader(jsonBody: request.generateJsonBodyAsString())
        let requestApi = RestApi().generedRequestPost(url: BaseURL.AuthenticatedReserveSeats, json: serviceBody)
    
        //ClickbusReserveSeatResponse.self
        callApi(EmptyObject.self, request: requestApi) { (response) in
            
            self.sendContact(fromClass: ClickBusRN.self, param: Param.Contact.CLICKBUS_RESERVE_SEAT_RESPONSE,
            result: response.sucess)
        }
    }
    
    func cancelReserveSeat(request: ClickbusCancelReserveSeatRequest) {

        // Create request
        let serviceBody = updateJsonWithHeader(jsonBody: request.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedCancelSeats, json: serviceBody)
        
        callApi(EmptyObject.self, request: request) { (response) in
            
            self.sendContact(fromClass: ClickBusRN.self, param: Param.Contact.CLICKBUS_CANCEL_SEAT_RESPONSE,
            result: response.sucess)
        }
    }
    
    func convertSeatsToSeatsRequest(seats: [ClickBusSeat], isGo: Bool) -> [ClickbusSeatRequest] {
        var requests = [ClickbusSeatRequest]()
        
        var request: ClickbusSeatRequest
        for seat in seats {
            request = ClickbusSeatRequest()
            request.seatId = seat.seatName
            request.passengerFirstName = seat.passenger?.getFirstName() ?? ""
            request.passengerLastName = seat.passenger?.getLastName() ?? ""
            request.passengerGender = "F"
            request.passengerDocument = seat.passenger?.document ?? ""
            request.passengerDocumentType = seat.passenger?.documentType ?? ""
            
            if isGo {
                request.tripId = QiwiOrder.clickBusCharge!.scheduleIdGo
                request.tripType = 1
            } else {
                request.tripId = QiwiOrder.clickBusCharge!.scheduleIdBack
                request.tripType = 2
            }
            
            requests.append(request)
        }
        
        return requests
    }
}

extension ClickBusRN: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if fromClass == AmazonRN.self {
                if param == Param.Contact.AMAZON_DOWNLOAD_FILE_RESPONSE {
                    do {
                        
                        let data = object as! Data
                        let buses = Mapper<ClickbusJSONBase>().map(JSONString: String(decoding: data, as: UTF8.self))
                        ClickBusCityDAO().insert(with: buses!.cities)
                        
                        ClickBusRN.setClickbusUpdateNeeded(needed: false)
                        self.sendContact(fromClass: ClickBusRN.self, param: Param.Contact.CLICKBUS_DOWNLOAD_CITIES_RESPONSE, result: true)
                    }
                    catch {
                        self.sendContact(fromClass: ClickBusRN.self, param: Param.Contact.CLICKBUS_DOWNLOAD_CITIES_RESPONSE, result: false)
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}
