//
//  PaymentType.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper
//import RealmSwift

class PaymentType: BasePojo {

    @objc dynamic var prvId: Int = 0
    @objc dynamic var idSlipType: Int = 0
    @objc dynamic var emitterId: Int = 0
    
    override public static func primaryKey() -> String? {
        return "prvId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        prvId <- map["PrvID"]
        idSlipType <- map["Id_Tipo_Boleto"]
        emitterId <- map["Id_Emissor"]
    }
}
