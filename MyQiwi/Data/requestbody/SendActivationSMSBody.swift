//
//  SendActivationSMSBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class SendActivationSMSBody : BasePojo {
    
    @objc dynamic var registerId : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        registerId <- map["id_cadastro"]
    }
    
    convenience init(registerId: Int) {
        self.init()
        
        self.registerId = registerId
    }
}
