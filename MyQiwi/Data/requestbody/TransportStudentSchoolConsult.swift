//
//  TransportStudentSchoolConsult.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 27/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportStudentSchoolConsult: BasePojo {
    
    @objc dynamic var idEmissor: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idEmissor <- map["idEmissor"]
    }
    
    convenience init(idEmissor: Int) {
        self.init()
        
        self.idEmissor = idEmissor
    }
}
