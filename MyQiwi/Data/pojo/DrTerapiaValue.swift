//
//  DrConsultaValue.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 10/07/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DrTerapiaValue: BasePojo {

    @objc dynamic var id: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var value: Int = 0

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["Id_Pin_Online_Valor"]
        desc <- map["Descricao"]
        value <- map["valor"]
    }
}
