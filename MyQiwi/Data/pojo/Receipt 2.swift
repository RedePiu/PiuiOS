//
//  Receipt.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class Receipt : BasePojo {
    
    var transitionId: Int = 0
    var receiptResume: String = ""
    var serviceValue: Double = 0
    var transitionValue: Double = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        transitionId <- map["Id_Transacao"]
        receiptResume <- map["Resumo_Recibo"]
        serviceValue <- map["Valor_Servico"]
        transitionValue <- map["Valor_Transacao"]
    }
}
