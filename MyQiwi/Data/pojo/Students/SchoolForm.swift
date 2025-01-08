//
//  SchoolForm.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 26/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class SchoolForm : BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var idSchool: Int = 0
    @objc dynamic var responsable: String = ""
    @objc dynamic var course: String = ""
    @objc dynamic var serie: String = ""
    @objc dynamic var nome: String = ""
    @objc dynamic var ra: String = ""
    @objc dynamic var schoolClass: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        idSchool <- map["IdEscolaProdata"]
        responsable <- map["ResponsavelEscola"]
        course <- map["CursoEscola"]
        serie <- map["SerieSemestreEscola"]
        nome <- map["Nome"]
        ra <- map["RA"]
        schoolClass <- map["Turma"]
    }
}
