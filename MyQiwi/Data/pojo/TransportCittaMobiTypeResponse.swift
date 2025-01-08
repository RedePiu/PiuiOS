//
//  TransportCittaMobiTypeResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 26/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportCittaMobiTypeResponse : BasePojo {
    
    @objc dynamic var desc: String = ""
    @objc dynamic var idCity: Int = 0
    @objc dynamic var maxValue: Int = 0
    @objc dynamic var minValue: Int = 0
    @objc dynamic var quota: Bool = false
    @objc dynamic var prvId: Int = 0
    @objc dynamic var cod: Int = 0
    @objc dynamic var taxDebitoCittamobi: Int = 0
    @objc dynamic var taxaCreditoCittamobi: Int = 0
    @objc dynamic var unitValue: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        desc <- map["DescricaoProduto"]
        idCity <- map["IdCidade"]
        maxValue <- map["MaxValue"]
        minValue <- map["MinValue"]
        quota <- map["Cota"]
        prvId <- map["PrvId"]
        cod <- map["CdProduto"]
        taxDebitoCittamobi <- map["TaxaDebitoCittamobi"]
        taxaCreditoCittamobi <- map["TaxaCreditoCittamobi"]
        unitValue <- map["ValorUnitario"]
    }
}
