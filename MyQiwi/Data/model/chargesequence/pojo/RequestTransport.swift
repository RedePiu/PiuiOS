//
//  RequestTransport.swift
//  MyQiwi
//
//  Created by Ailton on 04/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestTransport: BasePojo {
    
    var rechargeType: Int?
    var creditType: Int?
    var desc: String?
    var cardNumber: Int?
    var amount: Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        rechargeType <- map["TipoRecargaSPTrans"]
        creditType <- map["TipoCredito"]
        desc <- map["descricao"]
        cardNumber <- map["NumeroLogicoCartao"]
        amount <- map["Quantidade"]
    }
}
