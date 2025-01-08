//
//  CETContractAcception.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 01/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class CETContractAcception: BasePojo {
    
    @objc dynamic var userId: Int = 0
    @objc dynamic var isAccepted: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override public static func primaryKey() -> String? {
        return "userId"
    }
    
    override func mapping(map: Map) {
        userId <- map["userId"]
        isAccepted <- map["isAccepted"]
    }
    
    convenience init(userId: Int, isAccepted: Int) {
        self.init()
        
        self.userId = userId
        self.isAccepted = isAccepted
    }
    
    convenience init(userId: Int, isAccepted: Bool) {
        self.init()
        
        self.userId = userId
        self.isAccepted = isAccepted ? 1 : 0
    }
}
