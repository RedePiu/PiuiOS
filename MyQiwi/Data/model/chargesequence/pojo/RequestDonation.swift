//
//  RequestDonation.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 08/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestDonation: BasePojo {
        
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
    }
}

