//
//  ClickBusPojo.swift
//  MyQiwi
//
//  Created by Thyago on 09/09/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class SeatsBusPojo: BasePojo {
    
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var userId : Int = 0
    
    var data: BasePojo?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["nome"]
        userId <- map["userId"]
    }
}


