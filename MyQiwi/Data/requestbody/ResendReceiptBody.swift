//
//  ResendReceiptBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 28/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ResendReceiptBody : BasePojo {
    
    @objc dynamic var phone: String = ""
    @objc dynamic var orderId: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(phone: String, orderId: Int) {
        self.init()
        
        self.phone = phone
        self.orderId = orderId
    }
    
    override func mapping(map: Map) {
        phone <- map["telefone"]
        orderId <- map["id_pedido"]
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    //{"cod_ativacao":"342245","id_cadastro":9637}
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"telefone\":\"\(self.phone)\",\"id_pedido\":\(self.orderId)}"
        return bodyString
    }
}
