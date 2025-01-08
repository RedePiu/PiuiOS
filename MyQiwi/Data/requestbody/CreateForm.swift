//
//  CreateForm.swift
//  MyQiwi
//
//  Created by Daniel Catini on 17/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class CampoCreateForm: BasePojo {
    
    @objc dynamic var idCampo: Int = 0
    @objc dynamic var Valor: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idCampo <- map["id_campo"]
        Valor <- map["valor"]
    }
    
    convenience init(idCampo: Int, valor: String) {
        self.init()
        
        self.idCampo = idCampo
        self.Valor = valor
        
    }
}

class CreateForm: BasePojo {
    
    @objc dynamic var idEmissor: Int = 0
    @objc dynamic var id_formulario_tipo_cartao: Int = 0
    @objc dynamic var cpf: String = ""
    var campos: [CampoCreateForm] = [CampoCreateForm]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idEmissor <- map["id_emissor"]
        id_formulario_tipo_cartao <- map["id_formulario_tipo_cartao"]
        cpf <- map["cpf"]
        campos <- map["campos"]
    }
    
    convenience init(idEmissor: Int, id_formulario_tipo_cartao: Int, cpf: String, campos: [CampoCreateForm]) {
        self.init()
        
        self.idEmissor = idEmissor
        self.id_formulario_tipo_cartao = id_formulario_tipo_cartao
        self.cpf = cpf
        self.campos = campos
        
    }
}
