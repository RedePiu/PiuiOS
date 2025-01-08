//
//  TelesenaRN.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation

class TelesenaRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }

    public func getProductList() {
        
        var products = [TelesenaProduct]()
        
        // Create request
        let objectData = TelesenaProductsBody(prvid: QiwiOrder.getPrvID())
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetTeleSenaProductList, json: serviceBody)

        callApiForList(TelesenaProduct.self, request: request) { (response) in

            //If failed to get the baptism response
            if response.sucess {
                products = (response.body?.data)!
            }

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: TelesenaRN.self, param: Param.Contact.TELESENA_PRODUCTS_RESPONSE,
                             result: response.sucess, object: products as AnyObject)
        }
        
//        let p = TelesenaProduct()
//        p.desc = "EDIÇAO DE VERAO - R$ 19,90"
//        p.value = 1990
//        products.append(p)
//
//        self.sendContact(fromClass: TelesenaRN.self, param: Param.Contact.TELESENA_PRODUCTS_RESPONSE,
//                         result: true, object: products as AnyObject)
    }
}
