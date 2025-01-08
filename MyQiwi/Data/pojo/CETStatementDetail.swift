//
//  CETStatementDetail.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CETStatementDetail: BasePojo {
    
    @objc dynamic var orderId: Int = 0
    @objc dynamic var date: String = ""
    @objc dynamic var lat: Double = 0
    @objc dynamic var lon: Double = 0
    @objc dynamic var cetAuth: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var time: Int = 0
    @objc dynamic var amount: Int = 0
    @objc dynamic var value: Double = 0
    @objc dynamic var receipt: String = ""
    @objc dynamic var plate: String = ""
    
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
