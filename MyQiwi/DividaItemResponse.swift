//
//  DividaItemResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DividaItemResponse : BasePojo {
    
    var dividaId: Int = 0
    var lojaId: Int = 0
    var lojaName: String = ""
    var valueDivida: Double = 0
    var valueJuros: Double = 0
    var valueMulta: Double = 0
    var valueComission: Double = 0
    var valueBalance: Double = 0
    var dateVencimento: String = ""
    var datePagamento: String = ""
    var status: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        dividaId <- map["Id_Loja_Endereco_Divida"]
        lojaId <- map["Id_Loja_Endereco"]
        lojaName <- map["Nome_Loja_Endereco"]
        valueDivida <- map["Valor_Divida"]
        valueJuros <- map["Valor_Juros"]
        valueMulta <- map["Valor_Multa"]
        valueComission <- map["Valor_Comissao"]
        valueBalance <- map["Valor_Saldo"]
        dateVencimento <- map["Data_Vencimento"]
        datePagamento <- map["Data_Pagamento"]
        status <- map["Id_Status_Divida"]
    }
}
