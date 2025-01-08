//
//  BaseURL.swift
//  MyQiwi
//
//  Created by ailton on 08/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

public class BaseURL {

    static let CURRENT_URL = URL_PROD
    static let URL_PROD = "https://piu.tec.br:20383/qiwi"//"https://qiwinet.com.br:20181/qiwi"
    static let URL_DEV8078 = "http://52.44.243.59:8078/qiwi"
    static let URL_DEV8017 = "http://52.44.243.59:8017/qiwi"
    //static let URL_DEV8078 = "http://10.203.31.36:8078/qiwi"
    //static let URL_DEV8017 = "http://10.203.31.36:8017/qiwi"

    static let BaseURL = URL(string: CURRENT_URL)

    static var AuthenticatedBaptism : URL {
        return BaseURL!.appendingPathComponent("/batismo")
    }

    static var AutTest: URL {
        return URL(string: "http://www.mocky.io/v2/5b75cd9d2e00005000536228")!
    }

    static var AuthenticatedInitialization : URL {
        return BaseURL!.appendingPathComponent("/v2/inicializacao")
    }

    //--------------------- USER ----------------------------
    static var AuthenticatedRegister: URL {
        return BaseURL!.appendingPathComponent("/cadastro")
    }

    static var AuthenticatedRegisterActivation: URL {
        return BaseURL!.appendingPathComponent("/ativacao")
    }

    static var AuthenticatedLogin: URL {
        return BaseURL!.appendingPathComponent("/login")
    }

    static var AuthenticatedLogout: URL {
        return BaseURL!.appendingPathComponent("/logout")
    }
    
    static var AuthenticatedDelete: URL {
        return BaseURL!.appendingPathComponent("/usuario/excluir")
    }

    static var AuthenticatedSendActivationSMS: URL {
        return BaseURL!.appendingPathComponent("/reenvio")
    }

    static var AuthenticatedSendPasswordSMS: URL {
        return BaseURL!.appendingPathComponent("/alterasenha/solicita")
    }

    static var AuthenticatedChangePassword: URL {
        return BaseURL!.appendingPathComponent("/alterasenha")
    }

    static var AuthenticatedUserInfo: URL {
        return BaseURL!.appendingPathComponent("/usuario/info")
    }

    static var AuthenticatedQiwiBalance: URL {
        return BaseURL!.appendingPathComponent("/usuario/saldoqiwi")
    }

    static var AuthenticatedPrePagoBalance: URL {
        return BaseURL!.appendingPathComponent("/usuario/saldoprepago")
    }

    static var AuthenticatedStatements : URL {
        return BaseURL!.appendingPathComponent("/usuario/extratoQiwi")
    }

    static var AuthenticatedStatementsPrePago : URL {
        return BaseURL!.appendingPathComponent("/usuario/extratoPrePago")
    }

    static var AuthenticatedRemoveToken: URL {
        return BaseURL!.appendingPathComponent("/remove/cartaocredito")
    }

    static var AuthenticatedForgotQiwiPass: URL {
        return BaseURL!.appendingPathComponent("/contaqiwi/reenvio")
    }

    static var AuthenticatedRegisterCreditCard: URL {
        return BaseURL!.appendingPathComponent("/usuario/cartao/cadastrar/3")
    }

    static var AuthenticatedRegisterDocument: URL {
        return BaseURL!.appendingPathComponent("/usuario/documento/cadastrar")
    }

    static var AuthenticatedRegisterOrUpdateData: URL {
        return BaseURL!.appendingPathComponent("/usuario/dados/cadastroatualizacao")
    }

    static var AuthenticatedDeleteData: URL {
        return BaseURL!.appendingPathComponent("/usuario/dados/deletar")
    }

    static var AuthenticatedSetSeen: URL {
        return BaseURL!.appendingPathComponent("/usuario/documentos/visualizado")
    }

    static var AuthenticatedPromotionCode: URL {
        return BaseURL!.appendingPathComponent("/taxi/codigopromocional")
    }

    static var AuthenticatedGenerateQiwiPassCode: URL {
        return BaseURL!.appendingPathComponent("/contaqiwi/senha/geraCodigoSeguranca")
    }

    static var AuthenticatedChangeQiwiPass: URL {
        return BaseURL!.appendingPathComponent("/contaqiwi/senha/altera")
    }

    static var AuthenticatedAdesao: URL {
        return BaseURL!.appendingPathComponent("/usuario/adesao")
    }

    static var AuthenticatedQiwiPointsMap : URL {
        return BaseURL!.appendingPathComponent("/v2/pontos/consulta")
    }

    static var AuthenticatedEditCreditCard : URL {
        return BaseURL!.appendingPathComponent("/usuario/cartao/alterar")
    }
    
    static var AuthenticatedValidateCreditedValue : URL {
        return BaseURL!.appendingPathComponent("/usuario/cartao/validar")
    }
    
    static var AuthenticatedPendentCreditCards : URL {
        return BaseURL!.appendingPathComponent("/usuario/cartao/pendente")
    }

    static var AuthenticatedCommissionList : URL {
        return BaseURL!.appendingPathComponent("/usuario/comissao")
    }

    static var AuthenticatedAddCoupon : URL {
        return BaseURL!.appendingPathComponent("/usuario/cupom/add")
    }

    static var AuthenticatedGetDrTerapiaValues : URL {
        return BaseURL!.appendingPathComponent("/drterapia/consulta/")
    }

    //--------------------- RECEIPTS ----------------------------
    static var AuthenticatedGetReceipts : URL {
        return BaseURL!.appendingPathComponent("/usuario/recibo/consulta")
    }

    //--------------------- ULTRAGAZ ----------------------------
    static var AuthenticatedUltragazConsult : URL {
        return BaseURL!.appendingPathComponent("/ultragaz/Consulta")
    }

    //--------------------- ORDER ----------------------------
    static var AuthenticatedCheckoutRequest : URL {
        return BaseURL!.appendingPathComponent("/pedido/criar")
    }
    
    static var AuthenticatedGetPix : URL {
        return BaseURL!.appendingPathComponent("/pedido/pix/consulta")
    }

    static var AuthenticatedOrderStatus : URL {
        return BaseURL!.appendingPathComponent("/pedido/status")
    }

    static var AuthenticatedOrderList : URL {
        return BaseURL!.appendingPathComponent("/pedido/lista")
    }

    static var AuthenticatedComplementOrder: URL {
        return BaseURL!.appendingPathComponent("/pedido/adicionarcomplemento")
    }

    static var AuthenticatedComplementOrderPro: URL {
        return BaseURL!.appendingPathComponent("/usuario/extratoCredenciado")
    }

    static var AuthenticatedResendReceipt: URL {
        return BaseURL!.appendingPathComponent("/usuario/recibo/sms")
    }

    static var AuthenticatedCashback: URL {
        return BaseURL!.appendingPathComponent("/pedido/cashback")
    }

    //--------------------- PAYMENT PRE USER ----------------------------
    static var AuthenticatedPaymentLimitPreUser: URL {
        return BaseURL!.appendingPathComponent("v2/usuario/tipoPagamento")
    }

    //--------------------- PHONE CHARGE ----------------------------
    static var AuthenticatedOperatorList : URL {
        return BaseURL!.appendingPathComponent("/operadora/consulta")
    }

    static var AuthenticatedOperatorValueList : URL {
        return BaseURL!.appendingPathComponent("/operadora/consulta/valor")
    }

    static var AuthenticatedInternationalPhoneConsult : URL {
        return BaseURL!.appendingPathComponent("/Transferto/Consulta")
    }

    //--------------------- TOKEN ----------------------------
    static var AuthenticatedTokenValidation : URL {
        return BaseURL!.appendingPathComponent("/pedido/token/validar")
    }

    //--------------------- TRANSACTION ----------------------------
    static var AuthenticatedTransactionStatus : URL {
        return BaseURL!.appendingPathComponent("transacao/status")
    }

    static var AuthenticatedNewTransactionStatus : URL {
        return BaseURL!.appendingPathComponent("transacao/statuscomrecibo")
    }

    //--------------------- BILL ----------------------------
    static var AuthenticatedBillConsult : URL {
        return BaseURL!.appendingPathComponent("boleto/consulta")
    }

    //--------------------- TRANSPORT ----------------------------
    static var AuthenticatedTransportCardConsult : URL {
        return BaseURL!.appendingPathComponent("sptrans/consulta")
    }

    static var AuthenticatedTransportCardCittaMobiConsult : URL {
        return BaseURL!.appendingPathComponent("cittapag/consulta/produtos")
    }
    
    static var AuthenticatedTransportCardProdataConsult : URL {
        return BaseURL!.appendingPathComponent("prodata/consulta")
    }

    static var AuthenticatedTransportCardUrbsConsult : URL {
        return BaseURL!.appendingPathComponent("urbs/consulta")
    }

    static var AuthenticatedTransportCardPUrbsStatement : URL {
        return BaseURL!.appendingPathComponent("urbs/extrato")
    }

    //--------------------- CLICK BUS ----------------------------
    static var AuthenticatedScheduleConsult : URL {
        return BaseURL!.appendingPathComponent("clickBus/Consulta")
    }

    static var AuthenticatedTripDetails : URL {
        return BaseURL!.appendingPathComponent("clickbus/Detalhes")
    }

    static var AuthenticatedReserveSeats : URL {
        return BaseURL!.appendingPathComponent("clickbus/Reservar")
    }

    static var AuthenticatedCancelSeats : URL {
        return BaseURL!.appendingPathComponent("clickbus/CancelarReserva")
    }

    //--------------------- METROCARD ----------------------------
    static var AuthenticatedMetrocardProducts : URL {
        return BaseURL!.appendingPathComponent("metrocard/produtos")
    }

    static var AuthenticatedMetrocardBalance : URL {
        return BaseURL!.appendingPathComponent("metrocard/saldo")
    }
    
    //--------------------- STUDENT ----------------------------
    static var AuthenticatedStudentSchoolList : URL {
        return BaseURL!.appendingPathComponent("prodata/escola/consulta")
    }
    
    static var AuthenticatedStudentBusLineList : URL {
        return BaseURL!.appendingPathComponent("prodata/linha/consulta")
    }
    
    static var AuthenticatedStudentAddOrEditForm : URL {
        return BaseURL!.appendingPathComponent("prodata/formulario/add")
    }
    
    static var AuthenticatedProdataUpdateForm : URL {
        return BaseURL!.appendingPathComponent("prodata/formulario/update")
    }
    
    static var AuthenticatedStudentConsultForm : URL {
        return BaseURL!.appendingPathComponent("prodata/formulario/consulta")
    }
    
    static var AuthenticatedStudentGetForm : URL {
        return BaseURL!.appendingPathComponent("prodata/formulario/consulta/detalhe")
    }
    
    static var AuthenticatedTaxaGetCards : URL {
        return BaseURL!.appendingPathComponent("taxa/consulta/cadastro")
    }
    
    static var AuthenticatedTaxaGetCardTypes : URL {
        return BaseURL!.appendingPathComponent("taxa/menu/tipocarga")
    }
    
    static var AuthenticatedTaxaLayoutForm : URL {
        return BaseURL!.appendingPathComponent("taxa/formulario/layout")
    }
    
    static var AuthenticatedTaxaGetForms : URL {
        return BaseURL!.appendingPathComponent("taxa/formulario/consulta")
    }
    
    static var AuthenticatedTaxaCreateForm : URL {
        return BaseURL!.appendingPathComponent("taxa/formulario/add")
    }
    
    static var AuthenticatedTaxaUpdateForm : URL {
        return BaseURL!.appendingPathComponent("taxa/formulario/update")
    }
    
    static var AuthenticatedTaxaGet : URL {
        return BaseURL!.appendingPathComponent("taxa/consulta")
    }
    
    static var AuthenticatedCamposTaxaGet : URL {
        return BaseURL!.appendingPathComponent("taxa/consulta/campos")
    }
    
    //--------------------- CORREIO ----------------------------
    static var AuthenticatedConsultCEP: URL {
        return BaseURL!.appendingPathComponent("correios/consultacep")
    }

    //--------------------- PARKING ----------------------------
    static var AuthenticatedGetParkingCardBalance : URL {
        return BaseURL!.appendingPathComponent("cet/cad/consulta")
    }

    static var AuthenticatedSaveParkingVehicle : URL {
        return BaseURL!.appendingPathComponent("cet/veiculo/cadastrar")
    }

    static var AuthenticatedUpdateUserPlate : URL {
        return BaseURL!.appendingPathComponent("taxi/alterarplaca")
    }

    static var AuthenticatedDeleteParkingVehicle : URL {
        return BaseURL!.appendingPathComponent("cet/veiculo/excluir")
    }

    static var AuthenticatedGetParkingVehicleList : URL {
        return BaseURL!.appendingPathComponent("cet/veiculo/consulta")
    }

    static var AuthenticatedActiveParkingCad : URL {
        return BaseURL!.appendingPathComponent("cet/ativa")
    }

    static var AuthenticatedGetAvailableParkingLocal : URL {
        return BaseURL!.appendingPathComponent("cet/endereco/consulta")
    }

    static var AuthenticatedGetCETStatement : URL {
        return BaseURL!.appendingPathComponent("cet/extrato")
    }

    static var AuthenticatedGetCETStatementDetail : URL {
        return BaseURL!.appendingPathComponent("cet/extrato/detalhe")
    }

    //--------------------- DIVIDAS ----------------------------

    static var AuthenticatedGetDividaList : URL {
        return BaseURL!.appendingPathComponent("usuario/dividas")
    }

    static var AuthenticatedGetDividaTransacoes : URL {
        return BaseURL!.appendingPathComponent("usuario/divida/detalhe")
    }

    static var AuthenticatedPayDivida : URL {
        return BaseURL!.appendingPathComponent("usuario/divida/pagarV2")
    }

    static var AuthenticatedConsultaBoletoDivida : URL {
        return BaseURL!.appendingPathComponent("usuario/divida/boleto")
    }

    static var AuthenticatedDividaComplementCaixa: URL {
        return BaseURL!.appendingPathComponent("/divida/adicionarcomplemento")
    }
    
    //--------------------- Tele sena ----------------------------

    static var AuthenticatedGetTeleSenaProductList : URL {
        return BaseURL!.appendingPathComponent("tendenciaTelesena/consulta")
    }
}
