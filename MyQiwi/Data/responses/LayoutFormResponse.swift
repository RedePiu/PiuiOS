//
//  LayoutFormResponse.swift
//  MyQiwi
//
//  Created by Daniel Catini on 12/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class LayoutFormResponse: BasePojo {

    @objc dynamic var Id: Int = 0
    @objc dynamic var Id_Formulario_Tipo_Cartao: Int = 0
    @objc dynamic var Ordem: Int = 0
    @objc dynamic var Pagina: Int = 0
    @objc dynamic var Descricao: String = ""
    @objc dynamic var Tag: String = ""
    @objc dynamic var Id_Pai: Int = 0
    @objc dynamic var Observacao: String = ""
    @objc dynamic var Tamanho_Campo: Int = 0
    @objc dynamic var Fl_Obrigatorio: Bool = true
    @objc dynamic var Fl_Somente_Leitura: Bool = true
    @objc dynamic var Controle: String = ""
    @objc dynamic var Tipo_Parametro: String = ""
    
    override public static func primaryKey() -> String? {
        return "Id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        Id <- map["Id"]
        Id_Formulario_Tipo_Cartao <- map["Id_Formulario_Tipo_Cartao"]
        Ordem <- map["Ordem"]
        Pagina <- map["Pagina"]
        Descricao <- map["Descricao"]
        Tag <- map["Tag"]
        Id_Pai <- map["Id_Pai"]
        Observacao <- map["Observacao"]
        Tamanho_Campo <- map["Tamanho_Campo"]
        Fl_Obrigatorio <- map["Fl_Obrigatorio"]
        Fl_Somente_Leitura <- map["Fl_Somente_Leitura"]
        Controle <- map["Controle"]
        Tipo_Parametro <- map["Tipo_Parametro"]
    }
}

extension LayoutFormResponse {
    
    func getData() -> Data? {
        return nil
    }
}

