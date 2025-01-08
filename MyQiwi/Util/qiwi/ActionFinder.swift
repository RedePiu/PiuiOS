//
//  ActionFinder.swift
//  MyQiwi
//
//  Created by ailton on 26/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation
import CloudKit

class ActionFinder {

    // HOME
    public static let ACTION_TRANSPORT_CARD = 3
    public static let ACTION_TRANSPORT_CARD_CITTAMOBI = 33
    public static let ACTION_TRANSPORT_CARD_PRODATA = 51
    public static let ACTION_TRANSPORT_CARD_METROCARD = 41
    public static let ACTION_TRANSPORT_CARD_URBS = 42
    public static let ACTION_TRANSPORT_CARD_VEM = 43
    public static let ACTION_CLICK_BUS = 44
    public static let ACTION_INTERNATIONAL_CEL_RECHARGE = 47
    public static let ACTION_CEL_RECHARGE = 1
    public static let ACTION_PARKING = 2
    public static let ACTION_BILL_PAYMENT = 4
    public static let MENUID_OTHERS = 5
    public static let MENUID_OTHERS_NEW = 36
    public static let ACTION_OTHERSERVICES = 34
    public static let ACTION_INCOMM = 10
    public static let ACTION_PINOFFLINE = 11
    public static let ACTION_SERASA = 28
    public static let ACTION_CONSULTA_CPF = 29
    public static let ACTION_CONSULTA_CNPJ = 30
    public static let ACTION_RV = 31
    public static let ACTION_RV_SPOTIFY = 37
    public static let ACTION_DONATION = 46
    public static let ACTION_ULTRAGAZ = 48
    public static let ACTION_DRTERAPIA = 49
    public static let ACTION_TELESENA = 50
    
    
    // MORE SCREEN
    public static let QIWI_BALANCE_RECHARGE_PRVID = 17837
    public static let QIWI_BALANCE_TRANSFER_PRVID = 100083
    public static let QIWI_BALANCE_TRANSFER_FOR_PREPAGO_PRVID = 100171

    public static let ID_DAD_MORE_SCREEN = 19
    public static let ID_APP_INFO = 22
    public static let ID_APP_PREFERENCES = 23
    public static let ID_ADD_CREDIT_CARD = 24
    public static let ID_APP_POYNT_COMMISION = 25
    public static let ID_APP_TOKEN_VALIDATION = 26
    public static let ID_NOTIFICATION = 27
    public static let ID_ADESAO_DIGITAL = 28
    public static let ID_EDIT_PAYMENT_METHODS = 29
    public static let ID_APP_DIVIDA = 30
    public static let ID_STUDENT_FORM = 31
    public static let ID_EXCLUDE_USER = 32
    public static let ID_SHARE_APP = 33
    

    public static let PARKING_PRVID = 160930
    public static let PLAYSTATION_PLUS_PRVID = 100172

    struct TerminalType {
        static let SAO_PAULO = 1
        static let SAO_PAULO_TAXI = 2
        static let RIBEIRAO_PRETO = 3
        static let CURITIBA = 4
        static let TAUBATE = 5
    }

    struct OrderPro {
        static let TYPE_POS_PAGO = 1
        static let TYPE_PRE_PAGO = 2
        static let TYPE_ALL = 3
    }

    struct DividaPayments {

        struct Menus {
            static let TRANSFERENCIA = 1
            static let DEPOSITO = 2
            static let BOLETO = 3
            static let PIX = 4
        }

        struct PayService {
            static let DEPOSITO = 2
            static let TRANSFERENCIA = 3
            static let PIX = 4
        }
    }

    struct Prvids {
        static let BILHETE_UNICO = 100058
        static let URBS = 100157
        static let CITTAMOBI = 100133
        static let BOLETO_COBRANCA = 15222
        static let BOLETO_CONSUMO = 15223
        static let INTERNATIONAL_PHONE = 100167
        static let ULTRAGAZ = 100208
        static let TELESENA = 100250
        
        struct Prodata {
            
            static let RAPIDO_TAUBATE = 100267
            static let CAMPO_LIMPO = 100189
            static let CITY = 100188
            static let SIM_MAUA = 100187
            static let BR_CARD_SANTOS = 100186
            static let BEM_LEGAL = 100185
            static let CT_SANTOS = 100184
            static let BOM = 100183
            static let LEGAL = 100182
            static let NOSSO_RIBEIRAO = 100270
            static let VEM = 100181
            
            struct Dev {
                
                static let NOSSO_RIBEIRAO = 14672
            }
        }
    }

    // * Account constants are placed here
    struct PushActions {
        static let OPEN_ORDERS = 1
        static let INITIALIZATION = 2
        static let RESTART_APP = 3
        static let CALL_USER_INFO = 4
        static let OPEN_QIWIZINHOS = 5
        static let OPEN_TRANSITION = 6
    }

    struct Account {
        static let ID_DAD_ACCOUNT_OPTIONS = 13
        static let EDIT_PICTURE = 14
        static let SHOW_INFO = 15
        static let CHANGE_PASSWORD = 16
        static let QIWI_PASS = 17
        static let TERMS = 18
        static let RATE_APP = 19
        static let COMMISSION = 20
    }

    struct Documents {
        struct Status {
            static let NAO_ENVIADO = 0
            static let ANALISE = 1
            static let APROVADO = 2
            static let REPROVADO = 3
        }

        struct Types {
            static let CNH = 1
            static let CPF = 2
            static let RG = 3
            static let FACE_CARTAO = 4
            static let RNE = 5
            static let VIDEO = 6
            static let ADDRESS = 7
            static let STUDENT_OWN_DOCUMENT = 8
            static let STUDENT_DEPENDENT_DOCUMENT = 9
            static let SELFIE = 10
            static let FORMULARIO_EMTU = 11
            static let REQUERIMENTO_CARTAO_TRANSPORTE = 12
            static let DECLARACAO_ESCOLAR = 13
        }

        struct Names {
            static let CNH = "CNH"
            static let CPF = "CPF"
            static let RG = "RG"
            static let FACE_CARTAO = "Cartão de crédito"
            static let RNE = "RNE"
            static let VIDEO = "Vídeo"
        }
    }

    struct Bank {
        static let NO_BANK = 99999
        static let ITAU = 1
        static let BRADESCO = 2
        static let BANCO_DO_BRASIL = 3
        static let SANTANDER = 4
        static let CAIXA = 5
        static let PIX = 9
    }

    struct Bill {
        static let CONSUMO = 1
        static let COBRANCA = 2
    }

    struct CreditCard {
        static let ID_DAD_BRANDS = 40
        static let BRAND_MASTER = 41
        static let BRAND_VISA = 42
        static let BRAND_ELO = 43
    }

    struct Token {
        static let VALIDATION = 1
        static let LOGIN_VALIDATION = 2
    }

    struct Attendance {
        static let ID_DAD_ATTENDANCE_SCREEN = 29
        static let ID_CHAT = 30
    }

    struct Transport {
        static let ID_DAD_CHARGE_TYPE = 32
        static let ID_DAD_CHARGE_OPTIONS = 36

        struct MenuType {
            static let COMUM = 1
            static let DIARIO = 2
            static let SEMANAL = 3
            static let MENSAL = 4
            static let ESTUDANTE = 5
            static let ESTUDANTE_DIARIO = 6
            static let ESTUDANTE_SEMANAL = 7
            static let ESTUDANTE_MENSAL = 8
            static let BENEFICIO = 9
        }

        struct ChargeType {
            static let CREDITO_COMUM = 691
            static let DIARIO_INTEGRADO = 853
            static let DIARIO_TRILHO = 850
            static let DIARIO_ONIBUS = 847
            static let SEMANAL_INTEGRADO = 854
            static let SEMANAL_TRILHO = 851
            static let SEMANAL_ONIBUS = 848
            static let MENSAL_INTEGRADO = 855
            static let MENSAL_TRILHO = 852
            static let MENSAL_ONIBUS = 849

            static let ESTUDANTE_COMUM = 687
            static let ESTUDANTE_DIARIO_INTEGRADO = 862
            static let ESTUDANTE_DIARIO_TRILHO = 859
            static let ESTUDANTE_DIARIO_ONIBUS = 856
            static let ESTUDANTE_SEMANAL_INTEGRADO = 863
            static let ESTUDANTE_SEMANAL_TRILHO = 860
            static let ESTUDANTE_SEMANAL_ONIBUS = 857
            static let ESTUDANTE_MENSAL_INTEGRADO = 864
            static let ESTUDANTE_MENSAL_TRILHO = 861
            static let ESTUDANTE_MENSAL_ONIBUS = 858

            static let TAXA_SOLICITACAO_DE_BENEFICIO = 10000
        }

        struct MenuTypeCittaMobi {

            static let CIDADAO = 500
            static let ESTUDANTE = 900
            static let EXPRESS = 520
        }
        
        struct Prodata {
            
            struct NossoRibeirao {
                
                static let CIDADAO = 100270
                static let EXPRESSO = 100271
                static let ESTUDANTE = 100272
                
                static func GetDesc(prvid: Int) -> String {
                    
                    switch prvid {
                        case CIDADAO:
                            return "Cidadão"
                        case EXPRESSO:
                            return "Expresso"
                        case ESTUDANTE:
                            return "Estudante"
                        default:
                            return "Cidadão"
                    }
                }
            }
            
            struct RapidoTaubate {
                static let RAPIDO = 100267
                static let CIDADAO = 100268
                static let COMUM = 100204
                static let ESCOLAR = 100205
                static let VT = 100206
                static let EMPRESARIAL = 100207
                
                static let ESCOLAR_PRVLIST = [100205, 100379, 100381, 100379, 100382, 100383, 100384, 100385, 100205, 100386,
                    100387, 100388, 100389, 100381]
                
                static func IsEscolar(prvid: Int) -> Bool {
                    for prv in ESCOLAR_PRVLIST {
                        if prvid == prv {
                            return true
                        }
                    }
                    
                    return false
                }
            }
            
            struct BemLegalMaceio {
                static let COMUM = 100273
                static let ESTUDANTE = 100274
            }
            
            struct SaoVicente {
                /// **100490* SOU Sao Vicente - Comum Web
                /// **100491* SOU Sao Vicente - Estudante Web
                static let COMUM = 100490
                static let ESTUDANTE = 100491
            }
            
            struct SaoCarlos {
                /// **100493* SOU Sao Carlos - Comum Web
                /// **100494* SOU Sao Carlos - Faixa1 Web
                /// **100495* SOU Sao Carlos - Escolar Web
                /// **100496* SOU Sao Carlos - Faixa2 Web
                static let COMUM = 100493
                static let FAIXA1 = 100494
                static let ESCOLAR = 100495
                static let FAIXA2 = 100496
            }
            
            struct SaoSebastiao {
                /// **100500* SOU Sao Sebastiao - Comum Web
                /// **100501* SOU Sao Sebastiao - Escolar Web
                /// **100502* SOU Sao Sebastiao - Escolar Prefeitura Web
                static let COMUM = 100500
                static let ESCOLAR = 100501
                static let ESCOLARPREFEITURA = 100502
            }
            
            struct Caieiras {
                /// **100505* Caieiras BEM - Comum Web
                /// **100506* Caieiras BEM - Escolar Web
                static let COMUM = 100505
                static let ESCOLAR = 100506
            }
            
            struct Araraquara {
                static let COMUM = 100545
                static let COMUMC = 100547
                static let ESCOLAR = 100546
            }
            
            struct PresidentePrudente {
                /// **100508* SOU Presidente Prudente - Comum Web
                /// **100509* SOU Presidente Prudente - Escolar Web
                static let COMUM = 100508
                static let ESCOLAR = 100509
            }
            
            struct Indaiatuba {
                /// **100515* SOU Indaiatuba - Comum Web
                /// **100516* SOU Indaiatuba - Escolar Web
                static let COMUM = 100515
                static let ESCOLAR = 100516
            }
            
            struct Limeira {
                /// **100520* SOU Limeira - Comum Web
                /// **100521* SOU Limeira - Escolar Web
                static let COMUM = 100520
                static let ESCOLAR = 100521
            }
            
            struct Osasco {
                /// **100525* BEM Osasco - Comum Web
                /// **100526* BEM Osasco - Escolar Web
                static let COMUM = 100525
                static let ESCOLAR = 100526
            }
            
            struct FrancodaRocha {
                /// **100530* BEM Franco da Rocha - Comum Web
                /// **100531* BEM Franco da Rocha - Escolar Web
                /// **100727* BEM Franco da Rocha - Comum 1a Via - Entrega na Residencia
                /// **100728* BEM Franco da Rocha - Comum 2a Via - Entrega na Residencia
                /// **100729* BEM Franco da Rocha - Comum 2a Via - Retirada na Loja
                /// **100730* BEM Franco da Rocha - Estudante 1a Via - Entrega na Residencia
                /// **100731* BEM Franco da Rocha - Estudante 1a Via - Retirada na Loja
                /// **100732* BEM Franco da Rocha - Estudante 2a Via - Entrega na Residencia
                /// **100733* BEM Franco da Rocha - Estudante 2a Via - Retirada na Loja
                static let COMUM = 100530
                static let ESCOLAR = 100531
            }
            
            struct SantanadeParnaiba {
                /// **100535* BEM Santana de Parnaiba - Comum Web
                /// **100536* BEM Santana de Parnaiba - Escolar Web
                static let COMUM = 100535
                static let ESCOLAR = 100536
            }
            
            struct RioClaro {
                static let COMUM = 100572
                static let ESCOLAR = 100573
            }
            
            struct Cajamar {
                /// **100540* BEM Cajamar - Comum Web
                /// **100541* BEM Cajamar - Escolar Web
                /// **100720* BEM Cajamar - Comum 1a Via - Entrega na Residencia
                /// **100721* BEM Cajamar - Comum 2a Via - Entrega na Residencia
                /// **100722* BEM Cajamar - Comum 2a Via - Retirada na Loja
                /// **100723* BEM Cajamar - Estudante 1a Via - Entrega na Residencia
                /// **100724* BEM Cajamar - Estudante 1a Via - Retirada na Loja
                /// **100725* BEM Cajamar - Estudante 2a Via - Entrega na Residencia
                /// **100726* BEM Cajamar - Estudante 2a Via - Retirada na Loja
                static let COMUM = 100540
                static let ESCOLAR = 100541
            }
        
            static func GetDesc(prvid: Int) -> String {
                
                switch prvid {
                    case RapidoTaubate.RAPIDO:
                        return "Rápido"
                    case NossoRibeirao.CIDADAO: fallthrough
                    case RapidoTaubate.CIDADAO:
                        return "Cidadão"
                    case RapidoTaubate.ESCOLAR:
                        return "Escolar"
                    case RapidoTaubate.VT:
                        return "VT"
                    case RapidoTaubate.EMPRESARIAL:
                        return "Empresarial"
                case BemLegalMaceio.ESTUDANTE: fallthrough
                case NossoRibeirao.ESTUDANTE:
                        return "Estudante"
                    case NossoRibeirao.EXPRESSO:
                        return "Expresso"
                    default:
                        return "Comum"
                }
            }
        }

        struct CardType {
            /// **Atenção**
            /// - Não usar o tipo 6 - está como bilhete unico tbm
            /// - Os antigos também podem ser 0
            
            static let BILHETE_UNICO = 1
            static let NOSSO = 2
            static let URBS = 3
            static let METROCARD = 5
            static let BILHETE_UNICO2 = 6
            static let RAPIDO_TAUBATE = 7
            static let BEM_LEGAL = 8
            static let SAO_VICENTE = 9
            static let SAO_CARLOS = 10
            static let SAO_SEBASTIAO = 11
            static let CAIEIRAS = 12
            static let PRESIDENTE_PRUDENTE = 13
            static let INDAIATUBA = 14
            static let LIMEIRA = 15
            static let OSASCO = 16
            static let FRANCO_ROCHA = 17
            static let SANTANA_PARNAIBA = 18
            static let CAJAMAR = 19
            static let ARARAQUARA = 20
            static let RIO_CLARO = 21
        }

        struct UrbsCardType {
            static let COMUM = 1
            static let ESTUDANTE = 3
            static let VT = 2
            static let GRATUIDADE = 4
        }
    }

    struct Payments {
        static let ANY_PAYMENT = 0
        static let CREDIT_CARD = 1
        static let QIWI_BALANCE = 2
        static let BANK_TRANSFER = 3
        static let PRE_PAGO_LIMIT_AND_TAX = 4
        static let PROMO_CODE = 5
        static let PIX = 6
        static let QIWI_TRANSFER = 10
        static let MONEY = 11
        static let BILL = 12
        static let CREDIT_CARD_ATM = 13
        static let PIXV2 = 14
    }

    struct QiwiPoints {
        static let TYPE_MONEY = 5
        static let TYPE_CREDIT_CARD_ATM = 9
    }

    public static func isPrvIdFromAnyTransportCharge(prvId: Int) -> Bool {
        return prvId == ActionFinder.Prvids.BILHETE_UNICO ||
            prvId == ActionFinder.Prvids.URBS ||
            prvId == ActionFinder.Prvids.CITTAMOBI
    }
    
    public static func isActionFromAnyTransport(action: Int) -> Bool {
        return ActionFinder.isRechargeTransporCard(action: action) || ActionFinder.isRechargeTransporCardVem(action: action) || ActionFinder.isRechargeTransporCardUrbs(action: action) || ActionFinder.isRechargeTransporCardProdata(action: action) || ActionFinder.isRechargeTransporCardMetrocard(action: action) || ActionFinder.isRechargeTransporCardCittaMobi(action: action)
    }

    public static func isPrvFromBilheteUnico(prvId: Int) -> Bool {
        return prvId == ActionFinder.Prvids.BILHETE_UNICO
    }

    public static func isPrvFromUrbs(prvId: Int) -> Bool {
        return prvId == ActionFinder.Prvids.URBS
    }

    public static func isPrvFromCittaMobi(prvId: Int) -> Bool {
        return prvId == ActionFinder.Prvids.CITTAMOBI
    }

    public static func isClickBus(action: Int) -> Bool {
        return action == ActionFinder.ACTION_CLICK_BUS
    }

    public static func isRechargeTransporCard(action: Int) -> Bool {
        return action == ActionFinder.ACTION_TRANSPORT_CARD
    }

    public static func isRechargeTransporCardCittaMobi(action: Int) -> Bool {
        return action == ActionFinder.ACTION_TRANSPORT_CARD_CITTAMOBI
    }
    
    public static func isRechargeTransporCardProdata(action: Int) -> Bool {
        return action == ActionFinder.ACTION_TRANSPORT_CARD_PRODATA
    }

    public static func isRechargeTransporCardUrbs(action: Int) -> Bool {
        return action == ActionFinder.ACTION_TRANSPORT_CARD_URBS
    }

    public static func isRechargeTransporCardMetrocard(action: Int) -> Bool {
        return action == ActionFinder.ACTION_TRANSPORT_CARD_METROCARD
    }

    public static func isRechargeTransporCardVem(action: Int) -> Bool {
        return action == ActionFinder.ACTION_TRANSPORT_CARD_VEM
    }

    public static func isPhoneRecharge(action: Int) -> Bool {
        return action == ActionFinder.ACTION_CEL_RECHARGE
    }

    public static func isUltragaz(action: Int) -> Bool {
        return action == ActionFinder.ACTION_ULTRAGAZ
    }

    public static func isInternationalPhoneRecharge(action: Int) -> Bool {
        return action == ActionFinder.ACTION_INTERNATIONAL_CEL_RECHARGE
    }

    public static func isParking(action: Int) -> Bool {
        return action == ActionFinder.ACTION_PARKING
    }

    public static func isBillPayment(action: Int) -> Bool {
        return action == ActionFinder.ACTION_BILL_PAYMENT
    }

    public static func isOthers(action: Int) -> Bool {
        return action == ActionFinder.MENUID_OTHERS
    }

    public static func isRv(action: Int) -> Bool {
        return action == ActionFinder.ACTION_RV
    }

    public static func isRvSpotify(action: Int) -> Bool {
        return action == ActionFinder.ACTION_RV_SPOTIFY
    }

    public static func isIncomm(action: Int) -> Bool {
        return action == ActionFinder.ACTION_INCOMM
    }

    public static func isPinOffline(action: Int) -> Bool {
        return action == ActionFinder.ACTION_PINOFFLINE
    }

    public static func isDonation(action: Int) -> Bool {
        return action == ActionFinder.ACTION_DONATION
    }

    public static func isDrTerapia(action: Int) -> Bool {
        return action == ActionFinder.ACTION_DRTERAPIA
    }

    public static func isSerasa(action: Int) -> Bool {
        return action == ActionFinder.ACTION_SERASA
    }

    public static func isConsultingCPF(action: Int) -> Bool {
        return action == ActionFinder.ACTION_CONSULTA_CPF
    }

    public static func isConsultingCNPJ(action: Int) -> Bool {
        return action == ActionFinder.ACTION_CONSULTA_CNPJ
    }
    
    public static func isExcludeUser(action: Int) -> Bool {
        return action == ActionFinder.ID_EXCLUDE_USER
    }
    
    public static func isShareApp(action: Int) -> Bool {
        return action == ActionFinder.ID_SHARE_APP
    }

    public static func isAppInfo(action: Int) -> Bool {
        return action == ActionFinder.ID_APP_INFO
    }

    public static func isAisAddCreditcardppInfo(action: Int) -> Bool {
        return action == ActionFinder.ID_ADD_CREDIT_CARD
    }

    public static func isTokenValidation(action: Int) -> Bool {
        return action == ActionFinder.ID_APP_TOKEN_VALIDATION
    }

    public static func isQiwiRecharge(action: Int) -> Bool {
        return action == ActionFinder.QIWI_BALANCE_RECHARGE_PRVID
    }

    public static func isAppPreferences(action: Int) -> Bool {
        return action == ActionFinder.ID_APP_PREFERENCES
    }

    public static func isBilheteUnicoComum(id: Int) -> Bool {
        return id == Transport.ChargeType.CREDITO_COMUM
    }

    public static func isBilheteUnicoEstudante(id: Int) -> Bool {
        return isBilheteUnicoEstudanteComum(id: id) ||
            isBilheteUnicoEstudanteDiario(id: id) ||
            isBilheteUnicoEstudanteMensal(id: id) ||
            isBilheteUnicoEstudanteSemanal(id: id)
    }

    public static func isBilheteUnicoEstudanteComum(id: Int) -> Bool {
        return id == Transport.ChargeType.ESTUDANTE_COMUM
    }

    public static func isBilheteUnicoDiario(id: Int) -> Bool {
        return id == Transport.ChargeType.DIARIO_INTEGRADO ||
            id == Transport.ChargeType.DIARIO_ONIBUS ||
            id == Transport.ChargeType.DIARIO_TRILHO
    }

    public static func isBilheteUnicoEstudanteDiario(id: Int) -> Bool {
        return id == Transport.ChargeType.ESTUDANTE_DIARIO_INTEGRADO ||
            id == Transport.ChargeType.ESTUDANTE_DIARIO_ONIBUS ||
            id == Transport.ChargeType.ESTUDANTE_DIARIO_TRILHO
    }

    public static func isBilheteUnicoMensal(id: Int) -> Bool {
        return id == Transport.ChargeType.MENSAL_INTEGRADO ||
            id == Transport.ChargeType.MENSAL_ONIBUS ||
            id == Transport.ChargeType.MENSAL_TRILHO
    }

    public static func isBilheteUnicoEstudanteMensal(id: Int) -> Bool {
        return id == Transport.ChargeType.ESTUDANTE_MENSAL_INTEGRADO ||
            id == Transport.ChargeType.ESTUDANTE_MENSAL_ONIBUS ||
            id == Transport.ChargeType.ESTUDANTE_MENSAL_TRILHO
    }

    public static func isBilheteUnicoSemanal(id: Int) -> Bool {
        return id == Transport.ChargeType.SEMANAL_INTEGRADO ||
            id == Transport.ChargeType.SEMANAL_ONIBUS ||
            id == Transport.ChargeType.SEMANAL_TRILHO
    }

    public static func isBilheteUnicoEstudanteSemanal(id: Int) -> Bool {
        return id == Transport.ChargeType.ESTUDANTE_SEMANAL_INTEGRADO ||
            id == Transport.ChargeType.ESTUDANTE_SEMANAL_ONIBUS ||
            id == Transport.ChargeType.ESTUDANTE_SEMANAL_TRILHO
    }
}
