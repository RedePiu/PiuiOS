//
//  StudentFormStatusResponse.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 25/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class StudentFormStatusResponse : BasePojo {
    
    static var STATUS_NOT_FOUND: Int = 0
    static var STATUS_PENDENT: Int = 1
    static var STATUS_RETURN: Int = 2
    static var STATUS_REFUSED: Int = 3
    static var STATUS_APPROVED: Int = 4
    
    @objc dynamic var idForm: Int = 0
    @objc dynamic var idStatus: Int = 0
    @objc dynamic var status: String = ""
    @objc dynamic var reason: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        
        idForm <- map["idFormularioProdata"]
        idStatus <- map["idStatus"]
        status <- map["status"]
        reason <- map["motivo"]
    }
}
