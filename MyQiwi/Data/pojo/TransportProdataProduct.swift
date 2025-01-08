//
//  TransportProdataProducts.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 05/11/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportProdataProduct : BasePojo {
    
    @objc dynamic var prvId: Int = 0
    @objc dynamic var productCode: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var maxValue: Int = 0
    @objc dynamic var minValue: Int = 0
    @objc dynamic var unitValue: Int = 0
    @objc dynamic var isQuota: Bool = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        prvId <- map["id_prv"]
        productCode <- map["cod_produto"]
        desc <- map["descricao"]
        maxValue <- map["MaximumQuantity"]
        minValue <- map["MinimumQuantity"]
        unitValue <- map["UnitValue"]
        isQuota <- map["IsQuotaProduct"]
    }
}

