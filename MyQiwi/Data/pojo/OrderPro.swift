//
//  OrderPro.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class OrderPro : BasePojo {
    
    @objc dynamic var prvid: Int = 0
    @objc dynamic var product: String? = ""
    @objc dynamic var transitionValue: Double = 0
    @objc dynamic var value: Double = 0
    @objc dynamic var commission: Double = 0
    @objc dynamic var transactionId: Int = 0
    @objc dynamic var orderId: Int = 0
    @objc dynamic var canShow: Bool = false
    @objc dynamic var isPrePago: Bool = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(dividaDetails: DividaDetailsResponse) {
        self.init()
        
        self.prvid = dividaDetails.prvId
        self.product = dividaDetails.productName
        self.value = dividaDetails.valueTransition
        self.commission = dividaDetails.valueComission
        self.transactionId = dividaDetails.idTransition
    }
    
    convenience init(prvid: Int, product: String?, value: Double, commission: Double, isPrePago: Bool) {
        self.init()
        
        self.prvid = prvid
        self.product = product
        self.value = value
        self.commission = commission
        self.isPrePago = isPrePago
    }
    
    convenience init(prvid: Int, product: String?, value: Double, commission: Double, isPrePago: Bool, transitionId: Int) {
        self.init()
        
        self.prvid = prvid
        self.product = product
        self.value = value
        self.commission = commission
        self.isPrePago = isPrePago
        self.transactionId = transitionId
    }
    
    override func mapping(map: Map) {
        prvid <- map["id_Prv"]
        product <- map["Produto"]
        transitionValue <- map["ValorTransacao"]
        value <- map["ValorServico"]
        commission <- map["Comissao"]
        transactionId <- map["id_Transacao"]
        orderId <- map["id_pedido"]
        canShow <- map["Fl_Recibo"]
        isPrePago <- map["Fl_PrePago"]
    }
}

