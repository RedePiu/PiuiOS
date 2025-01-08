//
//  RequestTransportCittaMobi.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 21/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestTransportCittaMobi: BasePojo {
    
    @objc dynamic var cityId: Int = 1
    var cardNumber: Int?
    @objc dynamic var amount: Int = 1
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cityId <- map["IdCidade"]
        cardNumber <- map["NumeroLogicoCartao"]
        amount <- map["Quantidade"]
    }
}
