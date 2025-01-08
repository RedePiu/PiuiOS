//
//  GetTransactionBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class GetTransactionBody : BasePojo {
    
    @objc dynamic var transactionId : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        transactionId <- map["id_transacao"]
    }
    
    convenience init(transactionId: Int) {
        self.init()
        
        self.transactionId = transactionId
    }
}
