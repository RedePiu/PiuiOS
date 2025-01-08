//
//  UpdatePreUserdataResponse.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 20/04/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class UpdatePreUserdataResponse : BasePojo {
    
    var paymentLimits: [PaymentTypeLimitPrvId] = [PaymentTypeLimitPrvId]()
    var incommValues: [IncommValue] = [IncommValue]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        
        paymentLimits <- map["TipoPagamento"]
        incommValues <- map["Incomm"]
    }
}
