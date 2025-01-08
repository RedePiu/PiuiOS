//
//  ComplementOrderBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/05/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ComplementOrderBody: BasePojo {
    
    @objc dynamic var orderId: Int = 0
    @objc dynamic var complement: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(orderId: Int, complement: String) {
        self.init()
        
        self.orderId = orderId
        self.complement = complement
    }
    
    override func mapping(map: Map) {
        orderId <- map["Id_Pedido"]
        complement <- map["Complemento"]
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    //{"cod_ativacao":"342245","id_cadastro":9637}
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        //let bodyString = "{\"complemento\":\(self.complement),\"id_pedido\":\"\(self.orderId)\"}"
        let bodyString = "{\"Id_Pedido\":\(self.orderId),\"Complemento\":\"\(self.complement)\"}"
        return bodyString
    }
}
