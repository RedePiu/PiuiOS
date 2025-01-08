//
//  MetrocardRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class MetrocardRN: BaseRN {

    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }

    func consultCard(cpf: String, card: String) {
        
        let objectData = MetrocardUserBody(cpf: cpf, card: card, prvid: QiwiOrder.getPrvID())
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedMetrocardProducts, json: serviceBody)
        
        callApi(MetrocardProductsResponse.self, request: request) { (response) in
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: MetrocardRN.self, param: Param.Contact.METROCARD_PRODUCTS_RESPONSE,
                             result: response.sucess, object: response.body?.data)
        }
    }
    
    func getBalances(cpf: String, card: String) {
        
        let objectData = MetrocardUserBody(cpf: cpf, card: card, prvid: QiwiOrder.getPrvID())
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedMetrocardBalance, json: serviceBody)
        
        
        callApi(MetrocardBalance.self, request: request) { (response) in
            var balance = MetrocardBalance()
            
            if response.sucess {
                balance = response.body?.data ?? MetrocardBalance()
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: MetrocardRN.self, param: Param.Contact.METROCARD_BALANCE_RESPONSE,
                             result: response.sucess, object: balance)
        }
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
}
