//
//  Divida.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class Divida : BasePojo {
    
    @objc dynamic var dividaId: Int = 0
    @objc dynamic var lojaId: Int = 0
    @objc dynamic var lojaName: String = ""
    @objc dynamic var valueDivida: Double = 0
    @objc dynamic var valueJuros: Double = 0
    @objc dynamic var valueMulta: Double = 0
    @objc dynamic var valueComission: Double = 0
    @objc dynamic var valueBalance: Double = 0
    @objc dynamic var dateVencimento: String = ""
    @objc dynamic var datePagamento: String = ""
    @objc dynamic var status: Int = 0
    @objc dynamic var idBank: Int = 0
    @objc dynamic var complement: String = ""
    @objc dynamic var canPayParcial: Bool = false
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(lojaName: String, valueDivida: Double, dateVencimento: String, datePagamento: String, status: Constants.StatusDividas) {
        self.init()
        
        self.lojaName = lojaName
        self.valueDivida = valueDivida
        self.dateVencimento = dateVencimento
        self.datePagamento = datePagamento
        self.status = status.rawValue
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
        idBank <- map["Id_Banco"]
        complement <- map["Complemento_Preenchido"]
        canPayParcial <- map["fl_divida_parcial"]
    }
    
    static func getStatusName(status: Constants.StatusDividas) -> String {
        
        switch (status) {
        case Constants.StatusDividas.TODOS_STATUS:
            return ""
        case Constants.StatusDividas.PENDENTE:
            return "dividas_status_pendente".localized
        case Constants.StatusDividas.PAGO:
            return "dividas_status_paga".localized
        case Constants.StatusDividas.VENCIDO:
            return "dividas_status_vencida".localized
        case Constants.StatusDividas.PAGO_PARCIALMENTE:
            return "dividas_status_parcial".localized
        case Constants.StatusDividas.CANCELADO:
            return "dividas_status_cancelada".localized
        case Constants.StatusDividas.EM_ACORDO:
            return "dividas_status_em_acordo".localized
        }
    }
    
    func isVencido() -> Bool {
        return self.status == Constants.StatusDividas.VENCIDO.rawValue
    }
    
    func canShowPartialView() -> Bool {
        return canPayParcial && idBank == 0
    }
}
