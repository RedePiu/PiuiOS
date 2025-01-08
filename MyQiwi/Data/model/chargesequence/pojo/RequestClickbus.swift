//
//  RequestClickbus.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestClickbus: BasePojo {
    
    var sessionId: Int = 0
    var buyerBirthday: String = ""
    var buyerDocument: String = ""
    var buyerEmail: String = ""
    var buyerName: String = ""
    var buyerAge: String = ""
    var buyerLastName: String = ""
    var buyerLocation: String = ""
    var voucher: String = ""
    var deviceType: Int = 0
    var device: String = ""
    var password: String = ""
    var amount: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        sessionId <- map["sessionId"]
        buyerBirthday <- map["AniversarioComprador"]
        buyerDocument <- map["DocumentoComprador"]
        buyerEmail <- map["EmailComprador"]
        buyerName <- map["NomeComprador"]
        buyerAge <- map["IdadeComprador"]
        buyerLastName <- map["Sobrenome"]
        buyerLocation <- map["Localidade"]
        voucher <- map["Voucher"]
        deviceType <- map["tipoDispositivo"]
        device <- map["dispositivo"]
        password <- map["senha"]
        amount <- map["Qtd"]
    }
}
