//
//  StudentFormStatusBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 25/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class StudentFormStatusBody: BasePojo {
    
    @objc dynamic var cpf: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cpf <- map["Cpf"]
    }
    
    convenience init(cpf: String) {
        self.init()
        
        self.cpf = cpf
    }
}

