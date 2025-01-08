//
//  InternationalRechargeConsultResponse.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 01/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class InternationalRechargeConsultResponse : BasePojo {
    
    @objc dynamic var localCurrency: String = ""
    @objc dynamic var valueList: String = String()
    @objc dynamic var productIdList: String = String()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        
        localCurrency <- map["local_info_currency"]
        valueList <- map["local_info_value_list"]
        productIdList <- map["product_list"]
    }
}
