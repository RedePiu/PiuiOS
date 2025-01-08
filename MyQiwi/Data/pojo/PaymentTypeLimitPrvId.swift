//
//  PaymentTypeLimitPrvId.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper
//import RealmSwift

class PaymentTypeLimitPrvId: BasePojo {

    @objc dynamic var paymentId: Int = 0
    @objc dynamic var paymentType: Int = 0
    @objc dynamic var prvId: Int = 0
    @objc dynamic var minValue: Int = 0
    @objc dynamic var maxValue: Int = 0
    
    override public static func primaryKey() -> String? {
        return "paymentId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        paymentId <- map["Id_Tipo_Pagamento_Prvid"]
        paymentType <- map["Id_Tipo_Pagamento"]
        prvId <- map["Id_Prv"]
        minValue <- map["Valor_Minimo"]
        maxValue <- map["Valor_Maximo"]
    }
}
