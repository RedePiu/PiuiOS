//
//  UrbsBalanceResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class UrbsConsultResponse : BasePojo {
    
    @objc dynamic var canRecharge: Bool = false
    var balances: [UrbsBalance] = [UrbsBalance]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        
        canRecharge <- map["podeReceberRecargas"]
        balances <- map["saldos"]
    }
}
