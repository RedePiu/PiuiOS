//
//  ClickbusJSONBase.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 18/03/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickbusJSONBase: BasePojo {
    
    var cities = [ClickBusCity]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cities <- map["items"]
    }
}
