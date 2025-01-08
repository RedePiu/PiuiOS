//
//  UltragazRN.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 15/05/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation

class UltragazRN: BaseRN {

    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func consultValues(lat: Double, long: Double) {
        
        var products = [UltragazProduct]()
        
        // Create request
        let objectData = UltragazConsultBody(latitude: lat, longitude: long)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedUltragazConsult, json: serviceBody)
        
        callApiForList(UltragazProduct.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                products = (response.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: UltragazRN.self, param: Param.Contact.ULTRAGAZ_VALUES_RESPONSE, result: response.sucess, object: products as AnyObject)
        }
    }
}
