//
//  DividaPayDepositBody.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 20/07/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DividaPayDepositBody : BasePojo {
    
    @objc dynamic var idDivida : Int = 0
    @objc dynamic var idPaymentType : Int = 0
    @objc dynamic var value : Double = 0
    @objc dynamic var request : BankRequest? = BankRequest()
    var receipts : [DividaReceipt] = [DividaReceipt]()
    @objc dynamic var pixRequest: PIXRequest? = PIXRequest()
    @objc dynamic var partialType : Int = 0
    @objc dynamic var partialValue : Double = 0
    @objc dynamic var reason : String = ""
    var partialAttachments: [Anexo] = [Anexo]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idDivida <- map["Id_Loja_Endereco_Divida"]
        idPaymentType <- map["Id_Tipo_Lancamento_Bancario"]
        value <- map["valorTotal"]
        request <- map["transferencia"]
        receipts <- map["valores"]
        pixRequest <- map["pix"]
        partialType <- map["tipo_pagamento_parcial"]
        partialValue <- map["valorParcial"]
        reason <- map["motivo"]
        partialAttachments <- map["anexos_parcial"]
    }
    
    convenience init(idDivida: Int, idPaymentType: Int, value: Double, request: BankRequest?, receipts: [DividaReceipt], pixRequest: PIXRequest?, partialType: Int = 0, partialValue: Double = 0, reason: String = "", partialAttachments: [Anexo] = [Anexo]()) {
        self.init()
        self.idDivida = idDivida
        self.idPaymentType = idPaymentType
        self.value = value
        self.request = request
        self.receipts = receipts
        self.pixRequest = pixRequest
        self.partialType = partialType
        self.partialValue = partialValue
        self.reason = reason
        self.partialAttachments = partialAttachments
    }
}
