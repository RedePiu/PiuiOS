//
//  MetrocardBalanceResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class MetrocardBalance : BasePojo {
    
    var cpf : String = ""
    var date : String = ""
    var serieNumber : Int = 0
    var balance : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cpf <- map["CPF"]
        date <- map["DataSaldo"]
        serieNumber <- map["NumSerie"]
        balance <- map["SaldoEmCentavos"]
    }
}
