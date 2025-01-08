//
//  BodyHeaderResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class BodyHeaderResponse: BasePojo {
    
    @objc dynamic var terminalId: Int = 1
    @objc dynamic var seq: Int = -1
    @objc dynamic var f: String? = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        f <- map["f"]
        seq <- map["sequencial"]
        terminalId <- map["codterminal"]
    }
    
    convenience init(terminalId: Int, seq: Int, f: String) {
        self.init()
        
        self.terminalId = terminalId
        self.seq = seq
        self.f = f
    }
}
