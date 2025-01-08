//
//  ParkingRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 01/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class ParkingRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    /**
     * Get the user's current balance.<bR><br>
     * It will response thor Param: PARKING_CARDS_BALANCE_RESPONSE
     */
    func getCardBalance() {
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetParkingCardBalance, object: serviceBody)
        var balance = -1
        
        callApiDataInt(request: request) { (response) in
            
            if response.sucess {
                balance = response.body?.data ?? -1
            }
            
            self.sendContact(fromClass: ParkingRN.self, param: Param.Contact.PARKING_CARDS_BALANCE_RESPONSE, result: response.sucess, object: balance as AnyObject)
        }
    }
    
    /**
     * Verify is user already accepted the parking contract
     * @return True if it was accepted, false otherwise
     */
    func isParkingContractAccepted() -> Bool {
        let cetContractAcception = CetContractAcceptionDAO().get(userId: UserRN.getLoggedUserId())
        return cetContractAcception.isAccepted == 1
    }
    
    /**
     * Defines if the parking contract was accepted
     * @param accepted If it was accepted or not
     */
    func setParkingContractAccepted(isAccepted: Bool) {
        let dao = CetContractAcceptionDAO()
        let cetContractAcception = dao.get(userId: UserRN.getLoggedUserId())
        
        //Nao existe
        if cetContractAcception.userId == 0 {
            dao.insert(with: CETContractAcception(userId: UserRN.getLoggedUserId(), isAccepted: isAccepted))
        } else {
            dao.update(with: CETContractAcception(userId: UserRN.getLoggedUserId(), isAccepted: isAccepted))
        }
    }
    
    func needVerifyVehicles() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_NEED_VERIFY_VEHICLES)
    }
    
    func setNeedVerifyVehicles(needVerify: Bool) {
        UserDefaults.standard.set(needVerify, forKey: PrefsKeys.PREFS_NEED_VERIFY_VEHICLES)
    }
    
    /**
     * Get a list of statements.<bR><br>
     * It will response thor Param: PARKING_STATEMENT_RESPONSE
     */
    func getCETStatement(fromDate: String, toDate: String) {
        var statements: [CETStatementResponse] = []
        
        // Create request
        //let consultBody = QiwiStatement(fromDate: "2017-10-17T11:42:40", toDate: "2018-10-17T11:42:40")
        let consultBody = QiwiStatement(fromDate: fromDate, toDate: toDate)
        
        //At this case JSON must be ordened with a specific order.
        //updateJsonWithHeader must be called with generateJsonBody
        //A data object will be returned to send to the server
        let serviceBody = updateJsonWithHeader(jsonBody: consultBody.generateJsonBody())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetCETStatement, json: serviceBody)
        
        callApiForList(CETStatementResponse.self, request: request) { (statementResponses) in
            
            //If failed to get the baptism response
            if statementResponses.sucess {
                statements = (statementResponses.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: StatementRN.self, param: Param.Contact.PARKING_STATEMENT_RESPONSE,
                             result: statementResponses.sucess, object: statements as AnyObject)
        }
    }
    
    /**
     * Get the details of a statement.<bR><br>
     * It will response thor Param: PARKING_STATEMENT_DETAIL_RESPONSE
     */
    func getCETStatementDetail(cetTransactionId: Int) {
        let objectData = CETDetailRequest(cetTransactionId: cetTransactionId)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetCETStatementDetail, json: serviceBody)
        
        var objResponse = CETStatementDetail()
        
        callApi(CETStatementDetail.self, request: request) { (response) in
            
            if response.sucess {
                objResponse = response.body?.data ?? CETStatementDetail()
            }
            
            self.sendContact(fromClass: ParkingRN.self, param: Param.Contact.PARKING_STATEMENT_DETAIL_RESPONSE, result: response.sucess, object: objResponse as AnyObject)
        }
    }
    
    /**
     * Get a list of all saved plates from DB.<bR><br>
     * It will response thor Param: PARKING_LIST_RESPONSE
     */
    func getVehicleList() {
        var vehicles: [Vehicle] = []
        
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetParkingVehicleList, object: serviceBody)
        
        callApiForList(Vehicle.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                vehicles = (response.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: StatementRN.self, param: Param.Contact.PARKING_LIST_RESPONSE,
                             result: response.sucess, object: vehicles as AnyObject)
        }
    }
    
    /**
     * Make a request to get the list of vehicles and check if has at least one parked.
     * It will response throw Parking.Contact.PARKING_HAS_PARKED_VEHICLES_RESPONSE with a boolean value in result.
     */
    func hasParkedVahicles() {
        var hasVehicles = false
        var vehicles: [Vehicle] = []
        
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetParkingVehicleList, object: serviceBody)
        
        callApiForList(Vehicle.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                vehicles = (response.body?.data)!
                
                for vehicle in vehicles {
                    
                    if !vehicle.parkedDate.isEmpty {
                        hasVehicles = true
                        break
                    }
                }
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: StatementRN.self, param: Param.Contact.PARKING_HAS_PARKED_VEHICLES_RESPONSE,
                             result: hasVehicles, object: vehicles as AnyObject)
        }
    }
    
    func updateActivesAlarms(vehicles: [Vehicle]) {
        
    }
    
    func getWarningNotificationTime() -> Int {
        return 30000
    }
    
    /**
     * Get a list of all saved plates from DB.<bR><br>
     * It will response thor Param: PARKING_ACTIVE_CARD_RESPONSE
     */
    func activeParkingCard(parkingActiveRequest: RequestParking) {
        
        let stringJson = parkingActiveRequest.generateJsonBodyAsString()
        let serviceBody = updateJsonWithHeader(jsonBody: stringJson)
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedActiveParkingCad, json: serviceBody)
        
        callApi(request: request) { (response) in
            
            self.sendContact(fromClass: ParkingRN.self, param: Param.Contact.PARKING_ACTIVE_CARD_RESPONSE, result: response.sucess, object: response as AnyObject)
        }
    }
    
    /**
     * Updates or adds a Vehicle on local DB.<bR><br>
     * It will response thor Param: PARKING_SAVED
     */
    func addOrUpdateVeihicle(vehicle: Vehicle) {
        let stringJson = vehicle.generateJsonBodyAsString()
        let serviceBody = updateJsonWithHeader(jsonBody: stringJson)
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedSaveParkingVehicle, json: serviceBody)
        
        callApi(request: request) { (response) in
            
            self.sendContact(fromClass: ParkingRN.self, param: Param.Contact.PARKING_SAVED, result: response.sucess, object: response as AnyObject)
        }
    }
    
    /**
     * Removes a Vehicle on local DB.<bR><br>
     * It will response thor Param: PARKING_REMOVED
     */
    func removeVehicle(vehicle: Vehicle) {
        
        let objectData = ParkingDeleteVehicleRequest(plate: vehicle.plate)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedDeleteParkingVehicle, json: serviceBody)
        
        callApi(request: request) { (response) in

            self.sendContact(fromClass: ParkingRN.self, param: Param.Contact.PARKING_REMOVED, result: response.sucess, object: nil)
        }
    }
    
    /**
     * Get a list of card rules for parking recharge.<br><br>
     *
     * @return A list of main menu for parking recharge
     */
    func getCardRuleTypesList(rules: [RuleCET]) -> [RuleCET] {
        
        if !rules.isEmpty {
            return rules
        }
        
        var returnedRules = [RuleCET]()
        returnedRules.append(RuleCET(cadTime: 60))
        returnedRules.append(RuleCET(cadTime: 30))
        returnedRules.append(RuleCET(cadTime: 120))
        returnedRules.append(RuleCET(cadTime: 180))
        
        return returnedRules
    }
    
    /**
     * Get the list of available places to parking based on user's location.
     *
     * It will response thor Param: PARKING_AVAILABLE_LOCAL_RESPONSE
     */
    func getAvailableParkingLocal(latitude: Double, longitude: Double) {
        var adresses: [AddressCET] = []
        
        let objectData = AvailableParkingLocal(lat: latitude, long: longitude)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetAvailableParkingLocal, json: serviceBody)
        
        callApiForList(AddressCET.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                adresses = (response.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: StatementRN.self, param: Param.Contact.PARKING_AVAILABLE_LOCAL_RESPONSE,
                             result: response.sucess, object: adresses as AnyObject)
        }
    }

    /**
     * Get the list of value cet card.
     *
     * It will response thor Param: CET_VALUE_LIST_RESPONSE
     */
    func getValueCet() {
        
    }
}
