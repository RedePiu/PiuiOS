//
//  GetTaxasResponse.swift
//  MyQiwi
//
//  Created by Daniel Catini on 18/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class CamposGetTaxasResponse: BasePojo {

    @objc dynamic var Id_Campo: Int = 0
    @objc dynamic var Id_Tipo_Campo: Int = 0
    @objc dynamic var Tag: String = ""
    @objc dynamic var Descricao: String = ""
    
    override public static func primaryKey() -> String? {
        return "Id_Campo"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        Id_Campo <- map["id_campo"]
        Id_Tipo_Campo <- map["id_tipo_campo"]
        Tag <- map["tag"]
        Descricao <- map["descricao"]
    }
}

class GetTaxasResponse: BasePojo {

    @objc dynamic var Id_Taxa: Int = 0
    @objc dynamic var Id_Prv: Int = 0
    @objc dynamic var Valor_Taxa: Double = 0
    @objc dynamic var Valor_Adicional: Double = 0
    @objc dynamic var Nome: String = ""
    @objc dynamic var Id_Imagem: String = ""
    @objc dynamic var Via: Int = 0
    @objc dynamic var Fl_Entrega: Bool = true
    @objc dynamic var Tipo_Formulario: Int = 0
    var Campos: [CamposGetTaxasResponse]?
    
    override public static func primaryKey() -> String? {
        return "Id_Taxa"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        Id_Taxa <- map["id_taxa"]
        Id_Prv <- map["id_prv"]
        Valor_Taxa <- map["valor_taxa"]
        Valor_Adicional <- map["valor_adicional"]
        Nome <- map["nome"]
        Id_Imagem <- map["id_imagem"]
        Via <- map["via"]
        Fl_Entrega <- map["fl_entrega"]
        Tipo_Formulario <- map["tipo_formulario"]
    }
}
