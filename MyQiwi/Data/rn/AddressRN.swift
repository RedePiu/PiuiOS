//
//  AddressRN.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 30/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation

class AddressRN: BaseRN {
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func consultCEP(cep: String) {
        let objectData = RequestCepConsult(cep: cep)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedConsultCEP, json: serviceBody)
        
        callApi(CEPConsultResponse.self, request: request) { (response) in
            self.sendContact(
                fromClass: AddressRN.self,
                param: Param.Contact.ADDRESS_CONSULT_CEP_RESPONSE,
                result: response.sucess,
                object: response.body?.data
            )
        }
    }
}
