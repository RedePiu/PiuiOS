//
//  TaxaConsultaCartao.swift
//  MyQiwi
//
//  Created by Daniel Catini on 04/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class TaxaConsultaCartao: BasePojo {
    
    @objc dynamic var idEmissor: Int = 0
    @objc dynamic var cpf: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idEmissor <- map["id_emissor"]
        cpf <- map["cpf"]
    }
    
    convenience init(idEmissor: Int, cpf: String) {
        self.init()
        
        self.idEmissor = idEmissor
        self.cpf = cpf
        
    }
}
