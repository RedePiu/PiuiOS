//
//  ComprovanteDeposito.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 18/06/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation
import ObjectMapper

class ComprovanteDeposito: BasePojo {
    
    @objc dynamic var codigo: String = ""
    var anexos = [Anexo]()
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        codigo <- map["id_prv"]
        anexos <- map["nome"]
    }
    
    convenience init(codigo: String, anexos: [Anexo]) {
        self.init()
        
        self.codigo = codigo
        self.anexos = anexos
    }
}
