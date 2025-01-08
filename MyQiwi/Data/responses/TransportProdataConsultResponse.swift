//
//  TransportProdataConsultResponse.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 05/11/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportProdataConsultResponse : BasePojo {
    
    var creditTypes: [TransportProdataCreditType] = [TransportProdataCreditType]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        
        creditTypes <- map["tipo_creditos"]
    }
}
