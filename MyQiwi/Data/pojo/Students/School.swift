//
//  School.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 26/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class School : BasePojo {
    
    @objc dynamic var idSchool: Int = 0
    @objc dynamic var idEmissor: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var cep: String = ""
    @objc dynamic var street: String = ""
    @objc dynamic var number: String = ""
    @objc dynamic var district: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var tel: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idSchool <- map["idEscolaProdata"]
        idEmissor <- map["idEmissor"]
        name <- map["nome"]
        cep <- map["cep"]
        street <- map["logradouro"]
        number <- map["numero"]
        district <- map["bairro"]
        city <- map["cidade"]
        state <- map["estado"]
        tel <- map["telefone"]
    }
}
