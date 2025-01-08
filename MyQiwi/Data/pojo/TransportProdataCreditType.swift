//
//  TransportProdataResponse.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 05/11/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportProdataCreditType : BasePojo {
    
    @objc dynamic var typeCreditId: Int = 0
    @objc dynamic var desc: String = ""
    var products: [TransportProdataProduct] = [TransportProdataProduct]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        typeCreditId <- map["cod_tipo_credito"]
        desc <- map["descricao"]
        products <- map["produtos"]
    }
}
