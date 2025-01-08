//
//  TaxaConsultaTipoCarga.swift
//  MyQiwi
//
//  Created by Daniel Catini on 10/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class TaxaConsultaTipoCarga: BasePojo {
    
    @objc dynamic var idEmissor: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idEmissor <- map["id_emissor"]
    }
    
    convenience init(idEmissor: Int) {
        self.init()
        
        self.idEmissor = idEmissor
        
    }
}
