//
//  CreateOrderResponse.swift
//  MyQiwi
//
//  Created by Ailton on 25/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class CreateOrderResponse: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var date: String = ""
    var status: Status?
    @objc dynamic var descStatus: String = ""
    
    enum Status: Int {
        
        case canceled = 0
        case pendent
        case finished
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["Id_Pedido_Venda"]
        date <- map["Data_Pedido"]
        status <- map["Id_Status"]
        descStatus <- map["Status_Descricao"]
    }
}
