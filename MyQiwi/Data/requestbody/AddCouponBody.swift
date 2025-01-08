//
//  AddCouponBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class AddCouponBody: BasePojo {
    
    @objc dynamic var code: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(code: String) {
        self.init()
        
        self.code = code
    }
    
    override func mapping(map: Map) {
        code <- map["cod_cupom"]
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
        let bodyString = "{\"cod_cupom\":\"\(self.code)\"}"
        return bodyString
    }
}
