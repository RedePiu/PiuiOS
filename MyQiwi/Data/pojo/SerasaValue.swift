//
//  SerasaValue.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class SerasaValue: BasePojo {

    var id: Int = 0
    @objc dynamic var prvId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var maxValue: Double = 0
    @objc dynamic var minValue: Double = 0
    
    override public static func primaryKey() -> String? {
        return "prvId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        prvId <- map["PrvID"]
        name <- map["Name"]
        maxValue <- map["MaxPayValue"]
        minValue <- map["MinPayValue"]
    }
}
