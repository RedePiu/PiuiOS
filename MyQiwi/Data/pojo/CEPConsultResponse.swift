//
//  CEPConsultResponse.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 30/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class CEPConsultResponse : BasePojo {
    
    @objc dynamic var street: String = ""
    @objc dynamic var complement1: String = ""
    @objc dynamic var complement2: String = ""
    @objc dynamic var neighborhood: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var uf: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        street <- map["logradouro"]
        complement1 <- map["complemento"]
        complement2 <- map["complemento2"]
        neighborhood <- map["bairro"]
        city <- map["cidade"]
        uf <- map["uf"]
    }
}
