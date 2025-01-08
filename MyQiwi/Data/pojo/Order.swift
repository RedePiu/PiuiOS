//
//  Order.swift
//  MyQiwi
//
//  Created by ailton on 22/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import ObjectMapper

public class Order: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var idTransaction: Int = 0
    @objc dynamic var date: String = ""
    @objc dynamic var dateTransaction: String = ""
    @objc dynamic var value: Int = 0
    var status: Status = Status.pendent
    @objc dynamic var descStatus: String = ""
    @objc dynamic var valeGas: String = ""
    @objc dynamic var nsuGas: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var prvId: Int = 0
    @objc dynamic var receipt: String = ""
    var bankId: Int?
    var paymentMethod: Payment = Payment.null
    @objc dynamic var obs: String?
    @objc dynamic var bankAgency: String?
    @objc dynamic var bankAccount: String?
    @objc dynamic var bankAccountDv: String?
    @objc dynamic var details: String = ""
    @objc dynamic var complement: String = ""
    @objc dynamic var hasCashback: Bool = false
    @objc dynamic var cashbackValue: Int = 0
    
    enum Status: Int {
        case canceled = 0
        case pendent
        case finished
    }
    
    enum Payment: Int {
        case null = 0
        case credit_card = 1
        case qiwi_account = 2
        case bank_transfer = 3
        case pre_pago = 4
        case coupon = 5
        case pix = 6
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        id <- map["Id_Pedido_Venda"]
        idTransaction <- map["Id_Transacao"]
        date <- map["Data_Pedido"]
        dateTransaction <- map["Data_Transacao"]
        descStatus <- map["Status_Descricao"]
        value <- map["Valor_Transacao"]
        name <- map["nome_mobile"]
        prvId <- map["id_prv"]
        valeGas <- map["voucher_ultragaz"]
        nsuGas <- map["nsu_ultragaz"]
        details <- map["detalhe"]
        
        if map["comprovante"].isKeyPresent {
            receipt <- map["comprovante"]
        } else {
            receipt <- map["Comprovante"]
        }
        
        bankId <- map["Id_Banco_Conta"]
    
        bankAgency <- map["Agencia"]
        bankAccount <- map["Conta"]
        bankAccountDv <- map["Conta_DV"]
        obs <- map["Motivo_Cancelamento"]
        complement <- map["Complemento_Preenchido"]
        hasCashback <- map["fl_cashback"]
        cashbackValue <- map["valor_cashback"]
        
        if let statusValue = map["Id_Status"].currentValue as? Int {
            switch statusValue {
            case 0:
                status = .canceled
                break
            case 1:
                status = .pendent
                break
            case 2:
                status = .finished
                break
            default:
                break
            }
        }
        
        
        if let idPag = map["Id_Tipo_Pagamento"].currentValue as? Int {
            switch idPag {
            case 0:
                paymentMethod = .null
                break
            case 1:
                paymentMethod = .credit_card
                break
            case 2:
                paymentMethod = .qiwi_account
                break
            case 3:
                paymentMethod = .bank_transfer
                break
            case 4:
                paymentMethod = .pre_pago
                break 
            case 5:
                paymentMethod = .coupon
                break
            case 6:
                paymentMethod = .pix
                break
            default:
                break
            }
        }
    }
    
    convenience init(id: Int, prvid: Int, name: String, date: String, value: Int, status: Status, paymentMethod: Payment) {
        self.init()
        
        self.id = id
        self.prvId = prvid
        self.name = name
        self.date = date
        self.value = value
        self.status = status
        self.paymentMethod = paymentMethod
    }
    
    convenience init(id: Int, date: String, value: Int) {
        self.init()
        
        self.id = id
        self.date = date
        self.value = value
        self.status = .pendent
        self.paymentMethod = .null
    }
}

extension Order {
    
    func getOrderOrTransitionId() -> Int {
        return self.id > 0 ? self.id : self.idTransaction
    }
    
    
    func getOrderDate() -> String {
        return !self.date.isEmpty ? self.date : self.dateTransaction
    }
    
    func getPaymentOrder() -> String {
        
        if let paymentMethod = Order.Payment(rawValue: self.paymentMethod.rawValue) {
            
            switch paymentMethod {
                
            case .null:
                return "Nenhum pagamento"
            case .credit_card:
                return "payments_method_credit_card".localized
            case .qiwi_account:
                return "payments_method_qiwi_account".localized
            case .bank_transfer:
                return "payments_method_bank_transfer".localized
            case .pre_pago:
                return "payments_method_pre_pago".localized
            case .coupon:
                return "payments_method_coupon".localized
            case .pix:
                return "payments_method_pix".localized
            }
        }
        
        return ""
    }
    
    func isCaixaOrder() -> Bool {
        return self.paymentMethod.rawValue == ActionFinder.Payments.BANK_TRANSFER && self.bankId == ActionFinder.Bank.CAIXA
    }
    
    func isCaixaOrderCodeSent() -> Bool {
        return self.complement.count > 3
    }
    
    func getStatusOrder() -> String {
        
        if let statusOrder = Order.Status(rawValue: self.status.rawValue) {
            
            switch statusOrder {
                
            case .canceled:
                return "Cancelada"
            case .pendent:
//                if self.isCaixaOrder() {
//                    return self.isCaixaOrderCodeSent() ? "Código em validação" : "Aguardando código de operação"
//                }
//                
                return "Pendente"
            case .finished:
                return "Confirmado"
            }
        }
        
        return ""
    }
}
