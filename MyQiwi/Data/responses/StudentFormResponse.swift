//
//  StudentFormResponse.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 27/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class StudentFormResponse : BasePojo {
    
    @objc dynamic var idForm: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        
        idForm <- map["id_Cadastro_Formulario"]
    }
}
