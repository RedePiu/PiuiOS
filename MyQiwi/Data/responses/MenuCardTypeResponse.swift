//
//  MenuCardTypeResponse.swift
//  MyQiwi
//
//  Created by Daniel Catini on 10/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class MenuCardTypeResponse: BasePojo {

    @objc dynamic var Id_Tipo_Formulario_Carga: Int = 0
    @objc dynamic var Nome: String = ""
    @objc dynamic var codCarga: String = ""
    @objc dynamic var primeiraVia: Bool = false
    
    override public static func primaryKey() -> String? {
        return "Id_Tipo_Formulario_Carga"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        Id_Tipo_Formulario_Carga <- map["Id_Tipo_Formulario_Carga"]
        Nome <- map["Nome"]
        codCarga <- map["Cod_Carga"]
        primeiraVia <- map["Fl_1Via"]
    }
}

extension MenuCardTypeResponse {
    
    func getData() -> Data? {
        return nil
    }
}

