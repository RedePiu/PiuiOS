//
//  DividaPayBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DividaPayBody : BasePojo {
    
    @objc dynamic var idDivida : Int = 0
    @objc dynamic var idPaymentType : Int = 0
    @objc dynamic var value : Double = 0
    @objc dynamic var request : BankRequest? = BankRequest()
    var anexos : [Anexo] = [Anexo]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idDivida <- map["Id_Loja_Endereco_Divida"]
        idPaymentType <- map["Id_Tipo_Lancamento_Bancario"]
        value <- map["valor"]
        request <- map["transferencia"]
        anexos <- map["anexos_divida"]
    }
    
    convenience init(idDivida: Int, idPaymentType: Int, value: Double, request: BankRequest?, anexos: [Anexo]) {
        self.init()
        self.idDivida = idDivida
        self.idPaymentType = idPaymentType
        self.value = value
        self.request = request
        self.anexos = anexos
    }
}
