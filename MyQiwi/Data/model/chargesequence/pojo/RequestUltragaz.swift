//
//  RequestUltragaz.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/05/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestUltragaz : BasePojo {
    
    @objc dynamic var productCode: String = ""
    @objc dynamic var document: String = ""
    @objc dynamic var documentType: String = "CPF"
    @objc dynamic var email: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var productName: String = ""
    @objc dynamic var amount: Int = 1
    @objc dynamic var value: Int = 0
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0

    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        productCode <- map["CodProduto"]
        document <- map["Cpf"]
        documentType <- map["TipoDocumento"]
        email <- map["Email"]
        name <- map["Nome"]
        phone <- map["Telefone"]
        productName <- map["Produto"]
        amount <- map["Quantidade"]
        value <- map["Valor"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
    
    convenience init(productCode: String) {
        self.init()
        
        self.productCode = productCode
    }
    
    convenience init(productCode: String, latitude: Double, longitude: Double) {
        self.init()
        
        self.productCode = productCode
        self.latitude = latitude
        self.longitude = longitude
    }
}
