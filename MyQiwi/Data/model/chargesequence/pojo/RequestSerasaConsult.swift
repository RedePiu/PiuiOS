//
//  RequestSerasaConsult.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestSerasaConsult: BasePojo {
    
    @objc dynamic var whoIsConsulting: String = ""
    @objc dynamic var whoWillBeConsulted: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        whoIsConsulting <- map["consultante"]
        whoWillBeConsulted <- map["consultado"]
    }
    
    convenience init(whoWillBeConsulted: String) {
        self.init()
        
        self.whoWillBeConsulted = whoWillBeConsulted
    }
    
    //{"serasa":{"consultante":"","consultado":""},
}
