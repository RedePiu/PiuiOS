//
//  RequestInternationalPhone.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 31/03/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestInternationalPhone: BasePojo {
    
//    "Id_Pedido_Venda":"0",
//    "Numero_Telefone":"628123456770",
//    "Id_Produto":"1",
//    "Id_Reserva":"0",
//    "NSU_Parceiro":"0",
//    "Chave_Autenticacao":"0",
//    "Pin":"10",
//    "Valor":1000
    
    @objc dynamic var productId: String = ""
    @objc dynamic var phone: String = ""
    
    //Não são usados. Não preencher!
//    var idPedidoVenda: Int = 0
//    var idReserva = ""
//    var nsuParceiro = ""
//    var chaveAutenticacao = ""
//    var pin = ""
//    var valor = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        productId <- map["Id_Produto"]
        phone <- map["Numero_Telefone"]
//
//        idPedidoVenda <- map["Id_Pedido_Venda"]
//        idReserva <- map["Id_Reserva"]
//        nsuParceiro <- map["NSU_Parceiro"]
//        chaveAutenticacao <- map["Chave_Autenticacao"]
//        pin <- map["Pin"]
//        valor <- map["Valor"]
    }
}
