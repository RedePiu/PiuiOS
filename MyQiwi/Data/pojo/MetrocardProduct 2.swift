//
//  MetrocardProduct.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 28/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class MetrocardProduct : BasePojo {
    
    var productId : Int = 0
    var name : String = ""
    var unitValue : Int = 0
    var minValue : Int = 0
    var maxValue : Int = 0
    var daysForEnable : Int = 0
    var message : String = ""
    var maxBalance : Int = 0
    
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
