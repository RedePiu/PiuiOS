//
//  CETStatement.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 06/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CETStatement: BasePojo {
    
    var cetTransactionId: Int = 0
    var orderId: Int = 0
    var date: String = ""
    var name: String = ""
    var time: Int = 0
    var amount: Int = 0
    var value: Double = 0
    var plate: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cetTransactionId <- map["id_Transacao_CET"]
        orderId <- map["id_Pedido"]
        date <- map["Data"]
        name <- map["tipo"]
        time <- map["tempo"]
        amount <- map["quantidade"]
        value <- map["valor"]
        plate <- map["placa"]
    }
}
