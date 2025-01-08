//
//  OperatorValue.swift
//  MyQiwi
//
//  Created by Ailton on 18/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class OperatorValue: BasePojo {
    
    @objc dynamic var maxValue: Int = 0
    @objc dynamic var categoryId: Int = 0
    @objc dynamic var rechargeMessage: String = ""
    @objc dynamic var bonusValidate: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        maxValue <- map["valorMaximo"]
        categoryId <- map["idCategoria"]
        rechargeMessage <- map["mensagemRecarga"]
        bonusValidate <- map["validadeBonus"]
    }
}
