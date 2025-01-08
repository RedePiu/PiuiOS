//
//  MetrocardProduct.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 28/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class MetrocardProduct : BasePojo {
    
    @objc dynamic var productId : Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var unitValue : Int = 0
    @objc dynamic var minValue : Int = 0
    @objc dynamic var maxValue : Int = 0
    @objc dynamic var daysForEnable : Int = 0
    @objc dynamic var message : String = ""
    @objc dynamic var maxBalance : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        productId <- map["ProdutoId"]
        name <- map["Nome"]
        unitValue <- map["ValorUnitario"]
        minValue <- map["ValorMin"]
        maxValue <- map["ValorMax"]
        daysForEnable <- map["DiasParaHabilitarCompra"]
        message <- map["Mensagem"]
        maxBalance <- map["SaldoMaximoCartao"]
    }
}
