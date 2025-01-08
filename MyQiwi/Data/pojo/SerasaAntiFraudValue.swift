//
//  SerasaAntiFraudValue.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class SerasaAntiFraudValue: BasePojo {

    @objc dynamic var id: Int = 0
    @objc dynamic var prvId: Int = 0
    @objc dynamic var codproduto: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var maxValue: Double = 0
    @objc dynamic var minValue: Double = 0
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        prvId <- map["PrvID"]
        codproduto <- map["Cod_Produto"]
        name <- map["Nome_Produto"]
        desc <- map["Descricao_produto"]
        maxValue <- map["MaxPayValue"]
        minValue <- map["MinPayValue"]
    }
}
