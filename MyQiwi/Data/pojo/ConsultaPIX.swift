//
//  ConsultaPIX.swift
//  MyQiwi
//
//  Created by Daniel Catini on 10/07/23.
//  Copyright © 2023 Qiwi. All rights reserved.
//

import ObjectMapper

public class ConsultaPIX: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var idPedidoVenda: Int = 0
    @objc dynamic var idPagamentoPix: Int = 0
    @objc dynamic var qrCodePayload: String = ""
    @objc dynamic var validade: Int = 0
    @objc dynamic var status: Bool = false
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        id <- map["Id_Pedido_Venda_Pix"]
        idPedidoVenda <- map["Id_Pedido_Venda"]
        idPagamentoPix <- map["Id_Pagamento_Pix"]
        qrCodePayload <- map["QrCodePayload"]
        validade <- map["Validade"]
        status <- map["Status"]
    }
    
    convenience init(id: Int, idPedidoVenda: Int, idPagamentoPix: Int, qrCodePayload: String, validade: Int, status: Bool) {
        self.init()
        
        self.id = id
        self.idPedidoVenda = idPedidoVenda
        self.idPagamentoPix = idPagamentoPix
        self.qrCodePayload = qrCodePayload
        self.validade = validade
        self.status = status
    }
    
    
}

