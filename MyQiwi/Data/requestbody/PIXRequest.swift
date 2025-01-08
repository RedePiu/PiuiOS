//
//  PIXRequest.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 19/02/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation
import ObjectMapper

class PIXRequest: BasePojo {
    
    @objc dynamic var serverpk: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var document: String = ""
    @objc dynamic var save: Bool = false
    
    override public static func primaryKey() -> String? {
        return "document"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        name <- map["nome"]
        document <- map["documento"]
        save <- map["salvar"]
        serverpk <- map["id_agrupador_usuario"]
    }
    
    convenience init(name: String, document: String, save: Bool = false) {
        self.init()
        
        self.name = name
        self.document = document
        self.save = save
    }
}
