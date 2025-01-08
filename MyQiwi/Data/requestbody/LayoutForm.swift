//
//  LayoutForm.swift
//  MyQiwi
//
//  Created by Daniel Catini on 12/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class LayoutForm: BasePojo {
    
    @objc dynamic var idEmissor: Int = 0
    @objc dynamic var id_tipo_formulario_carga: Int = 0
    @objc dynamic var via: Int = 0
    @objc dynamic var fl_dependente: Bool = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idEmissor <- map["id_emissor"]
        id_tipo_formulario_carga <- map["id_tipo_formulario_carga"]
        via <- map["via"]
        fl_dependente <- map["fl_dependente"]
    }
    
    convenience init(idEmissor: Int, id_tipo_formulario_carga: Int, via: Int, fl_dependente: Bool) {
        self.init()
        
        self.idEmissor = idEmissor
        self.id_tipo_formulario_carga = id_tipo_formulario_carga
        self.via = via
        self.fl_dependente = fl_dependente
        
    }
}
