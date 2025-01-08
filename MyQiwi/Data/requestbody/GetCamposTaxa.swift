//
//  GetCamposTaxa.swift
//  MyQiwi
//
//  Created by Daniel Catini on 22/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class GetCamposTaxa: BasePojo {
    
    @objc dynamic var idTaxa: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idTaxa <- map["id_taxa"]
    }
    
    convenience init(idTaxa: Int) {
        self.init()
        
        self.idTaxa = idTaxa
    }
}
