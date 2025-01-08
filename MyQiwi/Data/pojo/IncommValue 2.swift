//
//  IncommValue.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class IncommValue: BasePojo {

    @objc dynamic var pk: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var prvId: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var minValue: Double = 0
    @objc dynamic var maxValue: Double = 0
    
    override public static func primaryKey() -> String? {
        return "pk"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["Id_Incomm_PrvID"]
        prvId <- map["PrvID"]
        desc <- map["Descricao"]
        minValue <- map["Valor_Minimo"]
        maxValue <- map["Valor_Maximo"]
    }
}
