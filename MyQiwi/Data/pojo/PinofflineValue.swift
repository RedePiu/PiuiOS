//
//  PinofflineValue.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class PinofflineValue: BasePojo {

    @objc dynamic var id: Int = 0
    @objc dynamic var prvId: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var value: Double = 0
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["Id_PinOffline_PrvId"]
        prvId <- map["PrvId"]
        desc <- map["Descricao"]
        image <- map["Id_Imagem"]
        value <- map["Valor"]
    }
}
