//
//  Constants.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/04/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

struct Constants {
    
    static var cpfTaxa:String = ""
    static var idTipoCarga: Int = 0
    static var viaCarga: Int = 0
    static var fl_verifica_form: Bool = false

    static let keyboardDistanceFromTextField = CGFloat(150)
    static let version = "\(Bundle.main.versionNumber).\(Bundle.main.buildNumber)"

    static let url_terms = "https://piu.com.br/termos-e-condicoes-de-uso/"
    static let bluezone_terms = "https://piu.com.br/termo-de-uso-cet-zona-azul/"

    struct KeysIdentity {
        static let NAME_APP = "QIWI_"
        static let PREFS_USER_ID = "PREFS_USER_ID"
        static let PREFS_USER_NAME = "PREFS_USER_NAME"
        static let PREFS_USER_EMAIL = "PREFS_USER_EMAIL"
        static let PREFS_USER_CPF = "PREFS_USER_CPF"
        static let PREFS_USER_CEL = "PREFS_USER_CEL"
        static let PREFS_USER_PICTURE = "PREFS_USER_PICTURE"
    }

    struct FormatPattern {

        enum Default: String {
            case CPF = "###.###.###-##"
            case CNPJ = "##.###.###/####-##"
            case BIRTHDAY = "##/##/####"
            case CEP = "#####-###"
        }

        enum CreditCard: String {
            case CVV = "###"
            case EXPIRY = "##/##"
            case NUMBER = "#### #### #### ####"
        }

        enum Bank: String {
            case DIGIT = "#"
            case AGENCY = "#######"
            case ACCOUNT = "#####-#"
        }

        enum Plaque: String {
            case LETTERS = "@@@"
            case NUMBERS = "####"
        }

        enum Cell: String {
            case dd = "##"
            case phone = "#####-####"
            case ddPhone = "(##) #####-####"
        }

        enum Bill: String {
            case boleto = "00000.00000\n00000.000000\n00000.000000\n0\n00000000000000"
            case boletoConsumo = "00000000000-0\n00000000000-0\n00000000000-0\n00000000000-0"
            case someLetters = "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
        }
    }

    struct Segues {
        static let HOME_TAB = "HOME_TAB"
        static let INFO_APP = "INFO_APP"
        static let TRANSPORT_CARD = "TRANSPORT_CARD"
        static let PHONE_RECHARGE = "PHONE_RECHARGE"
        static let PHONE_RECHARGE_PRO = "PHONE_RECHARGE_PRO"
        static let BLUE_ZONE = "BLUE_ZONE"
        static let BILL_PAYMENT = "BILL_PAYMENT"
        static let OTHER_PRODUCTS = "OTHER_PRODUCTS"
        static let TUTORIAL_NUMBER_CARD = "TUTORIAL_NUMBER_CARD"
        static let CARD_ADD = "CARD_ADD"
        static let LIST_GENERIC = "LIST_GENERIC"
        static let INTERNATIONAL_PHONE = "INTERNATIONAL_PHONE"
        static let INTERNATIONAL_PHONE_PRO = "INTERNATIONAL_PHONE_PRO"
        static let BILL_INSERT_CODE_BAR = "BILL_INSERT_CODE_BAR"
        static let BILL_DETAILS = "BILL_DETAILS"
        static let CHECKOUT = "CHECKOUT"
        static let TRANSPORT_QUOTE = "TRANSPORT_QUOTE"
        static let NO_BALANCE = "NO_BALANCE"
        static let SMS = "SMS"
        static let FORGOT_PASSWORD = "FORGOT_PASSWORD"
        static let REGISTER = "REGISTER"
        static let LOGIN = "LOGIN"
        static let WARNING_LOGOUT = "WARNING_LOGOUT"
        static let ORDER_DETAIL = "ORDER_DETAIL"
        static let ORDERS = "ORDERS"
        static let ORDERS_PRO = "ORDERS_PRO"
        static let NOTIFICATION = "NOTIFICATION"
        static let COMISSION = "COMISSION"
        static let STATUS_ORDER = "STATUS_ORDER"
        static let FORM_SMS = "FORM_SMS"
        static let FORM_WELCOME = "FORM_WELCOME"
        static let OTHER_INTRO = "OTHER_INTRO"
        static let SELECT_OPERATOR = "SELECT_OPERATOR"
        static let DOCUMENTS = "DOCUMENTS"
        static let SEND_DOCUMENTS_CHOOSE_DOCS = "SEND_DOCUMENTS_CHOOSE_DOCS"
        static let SEND_DOCUMENTS = "SEND_DOCUMENTS"
        static let DOC_TAKE_PICTURE = "DOC_TAKE_PICTURE"
        static let SHOW_RECEIPT = "SHOW_RECEIPT"
        static let COMING_SOON = "COMING_SOON"
        static let CREDIT_TRANSFER = "CREDIT_TRANSFER"
        static let FORGOT_QIWI_PASSWORD = "FORGOT_QIWI_PASSWORD"
        static let STUDANT_TAX = "STUDANT_TAX"
        static let PROMO_CODE = "PROMO_CODE"
        static let SERASA_CONSULT = "SERASA_CONSULT"
        static let CHOOSE_CPF = "CHOOSE_CPF"
        static let GENERIC_INPUT = "GENERIC_INPUT"
        static let QIWI_PASS_CHANGED = "QIWI_PASS_CHANGED"
        static let CREATE_QIWI_PASS = "CREATE_QIWI_PASS"
        static let EDIT_PAYMENT_METHODS = "EDIT_PAYMENT_METHODS"
        static let PAYMENT_MONEY = "PAYMENT_MONEY"
        static let INSTRUCT_VIDEO = "INSTRUCT_VIDEO"
        static let READ_CREDIT_CARD = "READ_CREDIT_CARD"
        static let CREDIT_CARD_PICTURE = "CREDIT_CARD_PICTURE"
        static let CREDIT_CARD_PREVIEW = "CREDIT_CARD_PREVIEW"
        static let WRITE_BILL = "WRITE_BILL"
        static let VIDEO_AGREEMENT = "VIDEO_AGREEMENT"
        static let BALANCE_URBS = "BALANCE_URBS"
        static let BALANCE_METROCARD = "BALANCE_METROCARD"
        static let URBS_STATEMENTS = "URBS_STATEMENTS"
        static let BACK_TO_CREDIT = "BACK_TO_CREDIT"
        static let QTOKEN = "QTOKEN"
        static let QTOKEN_STATUS = "QTOKEN_STATUS"
        static let HISTORICO_COMPRAS = "HISTORICO_COMPRAS"
        static let DIVIDAS = "DIVIDAS"
        static let DIVIDA_DETAILS = "DIVIDA_DETAILS"
        static let DIVIDA_TRANSFERENCIA = "DIVIDA_TRANSFERENCIA"
        static let DIVIDA_PIX = "DIVIDA_PIX"
        static let DIVIDA_DEPOSITO = "DIVIDA_DEPOSITO"
        static let DIVIDA_BARCODE = "DIVIDA_BARCODE"
        static let DIVIDA_TRANSACOES = "DIVIDA_TRANSACOES"
        static let DEPOSITO_EXAMPLE = "DEPOSITO_EXAMPLE"
        static let ULTRAGAZ = "ULTRAGAZ"
        static let ULTRAGAZ_USER = "ULTRAGAZ_USER"
        static let ULTRAGAZ_PRODUCTS = "ULTRAGAZ_PRODUCTS"
        static let TELESENA_VALUES = "TELESENA_VALUES"
        static let TELESENA_PREPAGO = "TELESENA_PREPAGO"
        static let STUDENT_HOME = "STUDENT_HOME"
        static let STUDENT_FORM = "STUDENT_FORM"
        static let STUDENT_FORM_STATUS = "STUDENT_FORM_STATUS"
        static let DELETEACCOUNT = "DELETEACCOUNT"
        
        static let TAXA_HOME = "TAXA_HOME"
        static let TAXA_CPF = "TAXA_CPF"
        static let TAXA_LIST_CARD = "TAXA_LIST_CARD"
        static let TAXA_FORM = "TAXA_FORM"
        static let TAXA_CONSULT_FORM = "TAXA_CONSULT_FORM"
        
        static let CLICK_BUS = "CLICK_BUS"
        static let DESTINATION_INPUT = "DESTINATION_INPUT"
        static let COMPANIES_LIST = "COMPANIES_LIST"
        static let SHOW_DATA = "SHOW_DATA"
        static let SHOW_TICKETS = "SHOW_TICKETS"
        static let SEE_SEATS = "SEE_SEATS"
        static let DATE_TRAVEL = "DATE_TRAVEL"
        static let CLICK_BUS_SELECT_CITY = "CLICK_BUS_SELECT_CITY"
    }

    enum StepListGeneric: Int {
        case SELECT_OPERATOR = 0
        case SELECT_OPERATOR_VALUE
        case SELECT_TRANSPORT_RECHARGE_TYPE
        case SELECT_TRANSPORT_CITTAMOBI_RECHARGE_TYPE
        case SELECT_TRANSPORT_PRODATA_RECHARGE_TYPE
        case SELECT_TRANSPORT_URBS_RECHARGE_TYPE
        case SELECT_TRANSPORT_WHERE_WILL_USE
        case SELECT_VALUE
        case SELECT_PAYMENT
        case SELECT_BANK
    }

    enum StepLogin: Int {

        case FORM_PHONE = 0
        case FORM_PASSWORD
    }

    enum StepCreateAccount: Int {

        case FORM_NAME = 0
        case FORM_CPF
        case FORM_EMAIL
        case FORM_BIRTHDAY
        case FORM_PHONE
        case FORM_PASSWORD
        case FORM_SMS
    }

    enum StepForgotPassword: Int {
        case FORM_CPF = 0
        case FORM_NEW_PASSWORD
        case FORM_STATUS
    }

    enum StepSelectPhoneRecharge: Int {
        case INSERT_PHONE = 0
        case SELECT_PHONE
        case SELECT_OPERATOR
    }
    
    enum StepSelectInternationalPhoneRecharge: Int {
        case INSERT_PHONE = 0
        case SELECT_PHONE
    }

    enum StepSelectCardNeedHelp : Int {
        case LIST = 0
        case SELECT
    }

    enum StepCheckout : Int {
        case ORDER = 0
        case BANK
        case QIWI_PASS
        case STATUS
    }

    enum StepBillPayment: Int {
        case VALUE
        case DUE_DATE
    }

    enum StepForgotPassQiwi: Int {
        case PHONE
        case SEND_SMS
    }

    enum StepReadCreditCard: Int {
        case LIST
        case NUMBER
        case NAME
        case EXPIRY
        case CVC
        case NICKNAME
        case CREDITED_VALUE
    }
    
    //    0    Todos
    //    1    Pendente
    //    2    Pago
    //    3    Vencido
    //    4    Pago Parcialmente
    //    5    Cancelado
    //    6    Em Acordo
        
    enum StatusDividas: Int {
        case TODOS_STATUS = 0
        case PENDENTE
        case PAGO
        case VENCIDO
        case PAGO_PARCIALMENTE
        case CANCELADO
        case EM_ACORDO
    }

    enum TipoBoleto: Int {
        case CONSUMO = 1
        case COBRANCA
        case NENHUM
    }

    enum StepsClickBusIda: Int {

        case NO_STEP = 0
        case DEPARTURE
        case DESTINATION
        case TRAVEL_OPTIONS
        case SEATS
        case PASSANGER
        case INPUT_EMAIL
        case PAYMENT
        case CHECKOUT
    }

    enum StepsClickBusIdaVolta: Int {
        
        case NO_STEP = 0
        case DEPARTURE
        case DESTINATION
        case TRAVEL_OPTIONS_GOING
        case TRAVEL_OPTIONS_RETURNING
        case SEATS_DEPARTURE
        case PASSANGER_DEPARTURE
        case SEATS_RETURNING
        case PASSANGER_RETURNING
        case INPUT_EMAIL
        case PAYMENT
        case CHECKOUT
    }

    
    struct Colors {

        struct Hex {
            static let first = "#0375BB"
            static let second = "#205180"
            static let toolbarColor = "#1B69B4"
            static let PRIMARY_HEX = "#FAAAA"
            static let colorPrimary = "#0075bc"
            static let colorPrimaryDark = "#074e79"
            static let colorAccent = "#f19700"
            static let colorBackground = "#fcf8f5"
            static let colorStatementItem = "#5a5e5a"
            static let white = "#ffffff"

            static let holo_red_light = "#ffff4444"

            // Selected Colors
            static let colorSelected = "#7e0987bf"
            static let colorUnselected = "#00000000"

            // BUTTON COLORS
            static let colorButtonOrange = "#f19700"
            static let colorButtonOrangeLight = "#ffba47"
            static let colorButtonBlue = "#0075bc"
            static let colorButtonBlueLight = "#2b92d1"
            static let colorButtonRed = "#ff716f"
            static let colorButtonRedLight = "#fc8a89"
            static let colorButtonGreen = "#66bb6a"
            static let colorButtonGreenLight = "#8dec91"
            static let colorButtonYellow = "#efce65"
            static let colorButtonYellowLight = "#fadc7a"
            static let colorBueBackground = "#0987BF"

            // Colors
            static let colorGrey1 = "#F5F5F5"
            static let colorGrey2 = "#EEEEEE"
            static let colorGrey3 = "#E0E0E0"
            static let colorGrey4 = "#BDBDBD"
            static let colorGrey5 = "#9E9E9E"
            static let colorGrey6 = "#757575"
            static let colorGrey7 = "#616161"
            static let colorGrey8 = "#424242"
            static let colorGrey9 = "#212121"

            // Other colors
            static let colorFacebook1 = "#3b5998"
            static let colorFacebook2 = "#8b9dc3"
            static let colorFacebook3 = "#dfe3ee"

            static let colorChatTime = "#919191"
            static let colorOrangelight = "#2ffdb9b5"
            static let colorReceipt = "#FFF8D0"

            // Color Credit Card
            static let default_color = "#363434"
            static let default_color_gradient = "#434141"
            static let chip_color = "#D4EDFA"
            static let chip_inner_color = "e0e4e4"
            static let chip_yellow_color = "#fbe191"
            static let chip_yellow_inner_color = "#eed280"
            static let text_shadow = "#7F000000"
            static let semi_white = "#88FFFFFF"
            static let pink_color = "#d04c84"
            static let pink_color_gradient = "#d04882"
            static let purple_color = "#5515a9"
            static let purple_color_gradient = "#651dc4"

            // QIWI COLORS
            static let colorQiwiOrange = "#ff9900"
            static let colorQiwiDarkorange = "#ff6622"
            static let colorQiwiLightorange = "#f3a93a"
            static let colorQiwiBlue = "#2266bb"
            static let colorQiwiDarkblue = "#003399"
            static let colorQiwiLightblue = "#66bbee"
            static let colorQiwiYellow = "#ffbb00"
            static let colorQiwiWhite = "#ffffff"
            static let colorQiwiDark = "#000000"
            static let colorQiwiGrey = "#888888"
            static let colorQiwiLightgrey = "#e2e2e2"
            static let colorQiwiMorelightgrey = "#f6f6f6"
        }
    }

    struct Image {

        struct Button {
            static let CHECK_BOX_ENABLE = #imageLiteral(resourceName: "ic_check_box").withRenderingMode(.alwaysTemplate)
            static let CHECK_BOX_DISABLED = #imageLiteral(resourceName: "ic_check_box_disable").withRenderingMode(.alwaysOriginal)
        }
        struct TabBar {
            static let HOME : UIImage = #imageLiteral(resourceName: "ic_home").withRenderingMode(.alwaysTemplate)
            static let EXTRACT : UIImage = #imageLiteral(resourceName: "ic_extract").withRenderingMode(.alwaysTemplate)
            static let SHOPPING : UIImage = #imageLiteral(resourceName: "ic_shopping").withRenderingMode(.alwaysTemplate)
            static let ATTENDANCE : UIImage = #imageLiteral(resourceName: "ic_attendance").withRenderingMode(.alwaysTemplate)
            static let MORE : UIImage = #imageLiteral(resourceName: "ic_more").withRenderingMode(.alwaysTemplate)
        }

        struct Navigation {
            static let BACK = #imageLiteral(resourceName: "ic_back_arrow").withRenderingMode(.alwaysTemplate)
        }

        struct Qiwi {
            static let LOGO_TOOLBAR =  #imageLiteral(resourceName: "piu_with_qiwi_lateral").withRenderingMode(.alwaysTemplate)
            static let LOGO = #imageLiteral(resourceName: "piu_with_qiwi_lateral")
            static let MASCOT = #imageLiteral(resourceName: "qiwi_mascot")
            static let MASCOT_CHAT = #imageLiteral(resourceName: "ic_mascot_chat")
        }
    }
}
