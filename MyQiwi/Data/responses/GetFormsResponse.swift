//
//  GetFormsResponse.swift
//  MyQiwi
//
//  Created by Daniel Catini on 18/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class CampoFormResponse: BasePojo {

    @objc dynamic var Id: Int = 0
    @objc dynamic var Id_Campo: Int = 0
    @objc dynamic var Valor: String = ""
    @objc dynamic var Fl_Validado: Bool = true
    
    override public static func primaryKey() -> String? {
        return "Id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        Id <- map["id"]
        Id_Campo <- map["id_campo"]
        Valor <- map["valor"]
        Fl_Validado <- map["fl_validado"]
    }
}

class GetFormsResponse: BasePojo {

    @objc dynamic var Id_Formulario: Int = 0
    @objc dynamic var Id_Emissor: Int = 0
    @objc dynamic var Id_Status: Int = 0
    @objc dynamic var Status: String = ""
    @objc dynamic var Id_Tipo_Carga: Int = 0
    @objc dynamic var Via: Int = 0
    @objc dynamic var Fl_Dependente: Bool = true
    @objc dynamic var Motivo: String = ""
          dynamic var Campos: [CampoFormResponse] = []
    
    
    override public static func primaryKey() -> String? {
        return "Id_Formulario"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        Id_Formulario <- map["id_formulario"]
        Id_Emissor <- map["id_emissor"]
        Id_Status <- map["id_status"]
        Status <- map["status"]
        Id_Tipo_Carga <- map["id_tipo_carga"]
        Via <- map["via"]
        Fl_Dependente <- map["fl_dependente"]
        Motivo <- map["motivo"]
        Campos <- map["campos"]
    }
}
