//
//  MarkSeatResult.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class MarkSeatResult : BasePojo {
    
    @objc dynamic var listQtd: Int = 0
    var results: [MarkSeatResult] = [MarkSeatResult]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        listQtd <- map["listQtd"]
        results <- map["Resultado"]
    }
}
