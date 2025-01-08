//
//  DependentStudent.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 26/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class DependentStudent : BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var rg: String = ""
    @objc dynamic var cpf: String = ""
    @objc dynamic var birthDate: String = ""
    @objc dynamic var father: String = ""
    @objc dynamic var mother: String = ""
    @objc dynamic var parent: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["Nome"]
        rg <- map["Rg"]
        cpf <- map["Cpf"]
        birthDate <- map["DataNascimento"]
        father <- map["NomePai"]
        mother <- map["NomeMae"]
        parent <- map["Parentesco"]
    }
}

