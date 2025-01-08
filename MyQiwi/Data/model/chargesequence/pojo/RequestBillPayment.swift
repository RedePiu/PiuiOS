//
//  RequestBillPayment.swift
//  MyQiwi
//
//  Created by ailton on 16/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestBillPayment: BasePojo {
    
    @objc dynamic var bankslip: RequestBankSlip? = RequestBankSlip()

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        bankslip <- map["boleto"]
    }
}
