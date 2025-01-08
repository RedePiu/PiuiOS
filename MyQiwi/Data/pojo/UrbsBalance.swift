//
//  UrbsBalance.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class UrbsBalance: BasePojo {
    
    @objc dynamic var canRecharge: Bool = false
    @objc dynamic var cardTypeCode: String = ""
    @objc dynamic var maxRechargeValue: Int = 0
    @objc dynamic var maxRechargeAmount: Int = 0
    @objc dynamic var balance: Double = 0
    @objc dynamic var balanceDate: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        canRecharge <- map["fl_Recarga"]
        cardTypeCode <- map["codigoTipoCartaoTransporte"]
        maxRechargeValue <- map["valorMaximoRecargas"]
        maxRechargeAmount <- map["quantidadeMaximaRecargas"]
        balance <- map["saldo"]
        balanceDate <- map["dataSaldo"]
    }
    
    convenience init(balance: Double, balanceDate: String) {
        self.init()
        
        self.balance = balance
        self.balanceDate = balanceDate
    }
}
