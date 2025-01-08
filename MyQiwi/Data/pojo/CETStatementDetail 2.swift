//
//  CETStatementDetail.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CETStatementDetail: BasePojo {
    
    var orderId: Int = 0
    var date: String = ""
    var lat: Double = 0
    var lon: Double = 0
    var cetAuth: String = ""
    var type: String = ""
    var time: Int = 0
    var amount: Int = 0
    var value: Double = 0
    var receipt: String = ""
    var plate: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        orderId <- map["id_Pedido"]
        date <- map["Data"]
        lat <- map["latitude"]
        lon <- map["longitude"]
        cetAuth <- map["authCET"]
        type <- map["tipo"]
        time <- map["tempo"]
        amount <- map["quantidade"]
        value <- map["valor"]
        receipt <- map["Recibo"]
        plate <- map["placa"]
    }
}
