//
//  CETDetailRequest.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class CETDetailRequest : BasePojo {
    
    @objc dynamic var cetTransactionId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cetTransactionId <- map["id_Transacao_CET"]
    }
    
    convenience init(cetTransactionId: Int) {
        self.init()
        
        self.cetTransactionId = cetTransactionId
    }
}

