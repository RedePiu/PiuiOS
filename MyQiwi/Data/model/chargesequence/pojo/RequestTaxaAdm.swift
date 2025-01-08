//
//  RequestTaxaAdm.swift
//  MyQiwi
//
//  Created by Daniel Catini on 22/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class CamposRequestTaxaAdm : BasePojo {
    
    @objc dynamic var id_campo: Int = 0
    @objc dynamic var valor_campo: String = ""

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id_campo <- map["id_campo"]
        valor_campo <- map["valor_campo"]
    }
}

class RequestTaxaAdm : BasePojo {
    
    @objc dynamic var cpf: String = ""
    @objc dynamic var id_taxa: Int = 0
    var lstCampos: [CamposRequestTaxaAdm]?

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cpf <- map["cpf"]
        id_taxa <- map["id_taxa"]
        lstCampos <- map["lstCampos"]
    }
}

