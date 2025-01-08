//
//  CreateFormResponse.swift
//  MyQiwi
//
//  Created by Daniel Catini on 17/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class CreateFormResponse: BasePojo {

    @objc dynamic var id_Cadastro_Formulario: Int = 0
    
    override public static func primaryKey() -> String? {
        return "id_Cadastro_Formulario"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id_Cadastro_Formulario <- map["id_Cadastro_Formulario"]
    }
}
