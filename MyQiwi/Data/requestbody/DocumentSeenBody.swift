//
//  DocumentSeenBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class DocumentSeenBody : BasePojo {
    
    @objc dynamic var processId : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        processId <- map["id_processo"]
    }
    
    convenience init(processId: Int) {
        self.init()
        
        self.processId = processId
    }
}
