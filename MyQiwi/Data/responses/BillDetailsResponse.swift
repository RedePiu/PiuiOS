//
//  BillDetailsResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class BillDetailsResponse: BasePojo {
    
    @objc dynamic var billTypeCode: Int = 0
    @objc dynamic var billType: String = ""
    @objc dynamic var billDesc: String = ""
    @objc dynamic var billValue: Int = 0
    @objc dynamic var validate: String = ""
    @objc dynamic var diff: Int = 0
    @objc dynamic var nsuHost: String = ""
    @objc dynamic var trnData: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        billTypeCode <- map["codTipoBoleto"]
        billType <- map["tipoBoleto"]
        billDesc <- map["descBoleto"]
        billValue <- map["valorBoleto"]
        validate <- map["vencimentoBoleto"]
        diff <- map["diffBoleto"]
        nsuHost <- map["nsuHost"]
        trnData <- map["trnData"]
    }
}
