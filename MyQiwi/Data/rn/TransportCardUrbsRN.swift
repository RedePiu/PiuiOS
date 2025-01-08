//
//  TransportCardUrbsRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class TransportCardUrbsRN : BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    /**
     * Obtem a lista de valores disponiveis, com base no valor maximo
     */
    func getAvailableValues(limiteMax: Int) -> [Int] {
        
        var list: [Int] = []
        
        let max = 42000 //limiteMax * 100
        
        if 1000 <= max {
            list.append(1000)
        }
        
        if 3000 <= max {
            list.append(3000)
        }
        
        if 5000 <= max {
            list.append(5000)
        }
        
        list.append(-1)
        return list
    }
    
    /*
     @cardNumber = Urbs card number
     @cardType = 1 comum / 5 - estudante
     */
    func consultCard(cardNumber: String) {
        let objectData = UrbsConsultBody(cardNumber: cardNumber)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTransportCardUrbsConsult, json: serviceBody)

        callApi(UrbsConsultResponse.self, request: request) { (response) in

            //If failed to get the baptism response
            if response.sucess {

            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportCardUrbsRN.self, param: Param.Contact.TRANSPORT_CARD_URBS_CONSULT_RESPONSE,
                             result: response.sucess, object: response.body?.data as! AnyObject)
        }
    }
    
    func consultCardStatement(cardNumber: String, daysBack: Int) {
        
        //let yearsToAdd = -1
        let currentDate = Date()
        
        var dateComponent = DateComponents()
        //dateComponent.year = yearsToAdd
        dateComponent.day = -daysBack
        
        let fromDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        consultCardStatement(cardNumber: cardNumber, fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: currentDate))
    }
    
    func consultCardStatement(cardNumber: String, month: Int, year: Int) {
        
        var dateComponent = DateComponents()
        dateComponent.setValue(month, for: .month)
        dateComponent.setValue(year, for: .year)
        dateComponent.setValue(1, for: .day)
        
        var toDateComponent = dateComponent
        toDateComponent.year = 0
        toDateComponent.month = 1 //pula um mes
        toDateComponent.day = -1 //volta 1 dia
        
        let fromDate = Calendar.current.date(from: dateComponent)
        let toDate = Calendar.current.date(byAdding: toDateComponent, to: fromDate!)
        
        consultCardStatement(cardNumber: cardNumber, fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: toDate!))
    }
    
    /*
     @cardNumber = Urbs card number
     @cardType = 1 comum / 5 - estudante
     */
    func consultCardStatement(cardNumber: String, fromDate: String, toDate: String) {
        
        let objectData = UrbsConsultStatement(cardNumber: cardNumber, initialDate: fromDate, finalDate: toDate)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTransportCardPUrbsStatement, json: serviceBody)

        var registries = [UrbsRegistry]()

        callApiForList(UrbsRegistry.self, request: request) { (response) in

            //If failed to get the baptism response
            if response.sucess && response.body?.data != nil {
                registries = response.body?.data ?? [UrbsRegistry]()
            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportCardUrbsRN.self, param: Param.Contact.TRANSPORT_CARD_URBS_STATEMENT_CONSULT_RESPONSE,
                             result: response.sucess, object: registries as! AnyObject)
        }
        
//        var registries = [UrbsRegistry]()
//        registries.append(UrbsRegistry(date: "2019-06-28T16:45:00", local: "Avenida Sete de Setembro", balance: 200.0, value: 4.20))
//        registries.append(UrbsRegistry(date: "2019-06-28T16:45:00", local: "Largo da Ordem", balance: 120.0, value: 4.20))
//        registries.append(UrbsRegistry(date: "2019-06-28T16:45:00", local: "Avenida da Santa Felicidade", balance: 80.0, value: 4.20))
//        registries.append(UrbsRegistry(date: "2019-06-28T16:45:00", local: "Rua Cristo Rei", balance: 100.0, value: 4.20))
//        registries.append(UrbsRegistry(date: "2019-06-28T16:45:00", local: "Rua Frederico Maurer", balance: 260.0, value: 4.20))
//        registries.append(UrbsRegistry(date: "2019-06-28T16:45:00", local: "Rua Anne Frank", balance: 400.0, value: 4.20))
//
//        self.sendContact(fromClass: TransportCardUrbsRN.self, param: Param.Contact.TRANSPORT_CARD_URBS_STATEMENT_CONSULT_RESPONSE,
//                         result: true, object: registries as! AnyObject)
    }
    
    func getChargeOptionsList(cardNumber: String) {
        let objectData = UrbsConsultBody(cardNumber: cardNumber)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTransportCardUrbsConsult, json: serviceBody)
        
        var menus = [MenuItem]()
        var balances = [UrbsBalance]()
        
        callApi(UrbsConsultResponse.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                
                if response.body?.data != nil && response.body?.data?.balances != nil && (response.body?.data!.canRecharge)! {
                    balances = (response.body?.data!.balances)!
                }
                
                for urbsBalance in balances {
                    
                    if !urbsBalance.canRecharge {
                        continue
                    }
                    
                    if Int(urbsBalance.cardTypeCode) == ActionFinder.Transport.UrbsCardType.COMUM {
                        menus.append(MenuItem(description: "comum", image: "ic_transport_comum", action: ActionFinder.Transport.UrbsCardType.COMUM, id: 0, data: urbsBalance))
                    }
                    else if Int(urbsBalance.cardTypeCode) == ActionFinder.Transport.UrbsCardType.ESTUDANTE {
                        menus.append(MenuItem(description: "estudante", image: "ic_studant", action: ActionFinder.Transport.UrbsCardType.ESTUDANTE, id: 0, data: urbsBalance))
                    }
                    else if Int(urbsBalance.cardTypeCode) == ActionFinder.Transport.UrbsCardType.VT {
                        menus.append(MenuItem(description: "vt", image: "ic_bus", action: ActionFinder.Transport.UrbsCardType.VT, id: 0, data: urbsBalance))
                    }
                    else if Int(urbsBalance.cardTypeCode) == ActionFinder.Transport.UrbsCardType.GRATUIDADE {
                        menus.append(MenuItem(description: "gratuidade", image: "ic_check_box", action: ActionFinder.Transport.UrbsCardType.GRATUIDADE, id: 0, data: urbsBalance))
                    }
                }
            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TransportCardUrbsRN.self, param: Param.Contact.TRANSPORT_CARD_URBS_AVAILABLE_CARDS_RESPONSE,
                             result: response.sucess, object: menus as AnyObject)
        }
    }
}
