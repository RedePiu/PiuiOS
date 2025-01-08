//
//  StatementTransactions.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class StatementTransactions: BasePojo {

    @objc dynamic var value: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var transactionId: Int = 0
    @objc dynamic var orderId: Int = 0
    @objc dynamic var canShowReceipt: Bool = true
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        value <- map["valor"]
        desc <- map["descricao"]
        transactionId <- map["id_transacao"]
        orderId <- map["id_pedido"]
        canShowReceipt <- map["Fl_Recibo"]
    }

    func getOrderOrTransitionId() -> Int {
        return self.orderId != 0 ? self.orderId : self.transactionId
    }
}
