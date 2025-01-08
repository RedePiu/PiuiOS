//
//  CETStatement.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 06/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CETStatement: BasePojo {
    
    @objc dynamic var cetTransactionId: Int = 0
    @objc dynamic var orderId: Int = 0
    @objc dynamic var date: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var time: Int = 0
    @objc dynamic var amount: Int = 0
    @objc dynamic var value: Double = 0
    @objc dynamic var plate: String = ""
    
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
