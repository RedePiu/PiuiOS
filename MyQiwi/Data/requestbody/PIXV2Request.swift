//
//  PixV2Request.swift
//  MyQiwi
//
//  Created by Daniel Catini on 06/07/23.
//  Copyright © 2023 Qiwi. All rights reserved.
//

import Foundation
//import RealmSwift
import ObjectMapper

class PIXV2Request : BasePojo {
    
    @objc dynamic var valor: Int = 0
    
    override public static func primaryKey() -> String? {
        return "valor"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        valor <- map["valor"]
    }
    
    convenience init(valor: Int) {
        self.init()
        
        self.valor = valor
    }
}

