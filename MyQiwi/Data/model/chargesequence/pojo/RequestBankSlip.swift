//
//  RequestBankSlip.swift
//  MyQiwi
//
//  Created by ailton on 16/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestBankSlip: BasePojo {
    
    @objc dynamic var nsuHost: String = ""
    @objc dynamic var barcode: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        nsuHost <- map["nsuHost"]
        barcode <- map["trnData"]
    }
}
