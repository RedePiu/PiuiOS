//
//  PaymentTypeLimit.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class PaymentTypeLimit: BasePojo {

    @objc dynamic var appid: Int = 0
    @objc dynamic var paymentId: Int = 0
    @objc dynamic var maxValue: Double = 0.0
    @objc dynamic var maxDeposit: Double = 0.0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        paymentId <- map["Id_Tipo_Pagamento"]
        maxValue <- map["Valor_Total"]
        maxDeposit <- map["Deposito_Total"]
    }
}
