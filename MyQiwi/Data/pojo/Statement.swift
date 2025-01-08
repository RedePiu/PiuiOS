//
//  Statement.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class Statement: BasePojo {

    @objc dynamic var date: String = ""
    @objc dynamic var balance: Int = 0
    var items: [StatementTransactions] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        date <- map["data"]
        balance <- map["saldo"]
        items <- map["transacoes"]
    }
    
    convenience init(date: String, balance: Int, items: [StatementTransactions]) {
        self.init()
        
        self.date = date
        self.balance = balance
        self.items = items
    }
}

extension Statement {
    
    func getRealBalance() -> Double {
        return Double(balance/100)
    }
}
