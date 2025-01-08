//
//  Params.swift
//  MyQiwi
//
//  Created by ailton on 19/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation

public final class Param {

    public static let OPERATIONAL_SYSTEM = "iOS"
    public static let APP_PACKAGE = "br.com.qiwi.MyQiwi"

    private init() {}

    // Necessário para  efetuar as chamadas rest
    public static var tokenFirebase = ""

    public final class Database {

        public static let DATABASE_NAME = "br.com.qiwi.MyQiwi"
        public static let DATABASE_VERSION = 1
    }

    public final class Net {
        public static let URL = "http://10.30.0.109:8082/"
        //prod https://qiwinet.com.br:20181/  dev http://10.30.0.109:8082/
        public static let PREFIX = "qiwi/"
    }

    public final class Contact {

        public static let ITEM_CLICK = 1
        public static let LIST_CLICK = 2
        public static let DIALOG_CLICK = 3
        public static let LIST_REMOVE_ITEM = 4
        public static let BACK_BUTTON = 5
        public static let GO_TO_STATEMENT = 11
        public static let SPLASH_FINISHED = 21
        public static let UPDATE_TOOLBAR_TITLE = 22
        public static let FINISH_ACTIVITY = 30
        public static let QIWI_BALANCE_RESPONSE = 40
        public static let PRE_PAGO_BALANCE_RESPONSE = 41
        public static let UPDATED_NBEEDED = 46
        public static let USER_INACTIVE = 47
        public static let NO_VALUES_AVAILABLE = 48
        public static let BANK_SELECTED = 49
        public static let PHOTO_ADDED = 50
        public static let DATAPICKER_RESPONSE = 51
        public static let QIWIPOINTS_RESPONSE = 52
        public static let MENU_CLICK = 53
        public static let NEED_UPDATE_DATA = 54
        public static let TOKEN_VALIDATION_RESPONSE = 55
        public static let BANK_INPUT_SELECTED = 56
        public static let CLICK_CANCEL = 57
        public static let ADD_COUPON_RESPONSE = 58
        public static let ULTRAGAZ_VALUES_RESPONSE = 59
        public static let DRTERAPIA_VALUES_RESPONSE = 60
        public static let TELESENA_PRODUCTS_RESPONSE = 61
        public static let SHOW_ONLY_BACK_BUTTON = 62
        public static let SHOW_BACK_AND_CONTINUE_BUTTON = 63
        public static let PUSH_TOKEN_REGISTERED = 64

        public static let FINISH = 70
        public static let UPDATE_PASSENGERS = 71
        public static let UPDATE_CELL_HEIGHT = 72
        public static let USER_ADDED_TO_ARRAY = 73
        public static let USER_UPDATED_IN_ARRAY = 74
        public static let USER_REMOVED_FROM_ARRAY = 75

        public static let CHECKOUT_REQUEST = 101
        public static let CHECKOUT_REQUEST_FAILED = 102
        public static let CHECKOUT_CHECK_TAX_RESPONSE = 103
        public static let CHECKOUT_RESEND_RECEIPT_RESPONSE = 104
        public static let CHECKOUT_REQUEST_PIX = 105

        public static let USER_LOGIN = 151
        public static let USER_LOGIN_FB = 152
        public static let USER_LOGOUT = 153
        public static let USER_REGISTER = 154
        public static let USER_REGISTER_FB = 155
        public static let USER_SMS_PASSWORD_SENT = 156
        public static let USER_CHANGE_PASSWORD = 157
        public static let USER_SEND_SMS = 158
        public static let USER_SMS_VALIDATION_REGISTER = 159
        public static let USER_INFO_RESPONSE = 161
        public static let USER_QIWI_PASS_WRONG_ERROR = 162
        public static let USER_FORGOT_QIWI_PASS = 163
        public static let USER_PROMO_CODE = 164
        public static let USER_SEND_SMS_QIWI_PASSWORD = 165
        public static let USER_CHANGE_QIWI_PASSWORD = 166
        public static let USER_ADESAO_RESPONSE = 167
        public static let USER_COMMISSION_LIST_RESPONSE = 168

        public static let MENU_ACCOUNT_OPTIONS = 203
        public static let MENU_MORE_SERVICES = 205

        public static let PHONE_RECHARGE_OP_LIST_RESPONSE = 301
        public static let PHONE_RECHARGE_OP_LIST_AS_MENU_RESPONSE = 302
        public static let PHONE_RECHARGE_AVAILABLE_VALUES_RESPONSE = 303
        public static let PHONE_RECHARGE_AVAILABLE_VALUES_AS_MENU_RESPONSE = 304
        public static let PHONE_RECHARGE_VERIFY_OPERATOR_RESPONSE = 305
        public static let PHONE_RECHARGE_DELETE_PHONE_RESPONSE = 306
        public static let PHONE_RECHARGE_INSERT_PHONE_RESPONSE = 307
        public static let PHONE_INTERNATIONAL_RECHARGE_CONSULT_RESPONSE = 308

        public static let BILL_REQUEST_RESPONSE = 351

        public static let LOCATION_GOOGLE_API_FAILED = 402
        public static let LOCATION_SETTED = 403

        public static let NET_REQUEST_ERROR = 451
        public static let NET_BAPTISM_RESPONSE = 452
        public static let NET_REQUEST_NO_NETWORK = 453

        public static let ORDERS_GET_LIST = 501
        public static let ORDERS_ORDER_RESPONSE = 502
        public static let ORDERS_ORDER_LIST_RESPONSE = 503
        public static let ORDERS_TRANSACTION_RESPONSE = 504
        public static let ORDERS_SEND_COMPLEMENT_RESPONSE = 505
        public static let ORDER_PRO_LIST_RESPONSE = 506
        public static let ORDER_CASHBACK_CONFIRMATON = 507
        public static let ORDERS_PIX_RESPONSE = 508

        public static let TRANSPORT_CARD_CONSULT_RESPONSE = 551
        public static let TRANSPORT_CARD_CITTAMOBI_CONSULT_RESPONSE = 552
        public static let TRANSPORT_CARD_URBS_CONSULT_RESPONSE = 553
        public static let TRANSPORT_CARD_SAVED = 554
        public static let TRANSPORT_CARD_REMOVED = 555
        public static let TRANSPORT_CARD_URBS_STATEMENT_CONSULT_RESPONSE = 556
        public static let TRANSPORT_CARD_URBS_AVAILABLE_CARDS_RESPONSE = 557
        public static let TRANSPORT_CARD_PRODATA_CONSULT_RESPONSE = 558

        public static let QIWI_STATEMENT_RESPONSE = 601

        public static let DOCS_DOCUMENT_SEEN_RESPONSE = 651
        public static let DOCS_SEND_DOC_RESPONSE = 652
        public static let DOCS_OPEN_DOC_STATUS = 653
        public static let DOCS_SEND_VIDEO_RESPONSE = 654
        public static let AMAZON_DOWNLOAD_FILE_RESPONSE = 655

        public static let CREDIT_CARD_LIST_RESPONSE = 701
        public static let CREDIT_SEND_CREDITCARD_RESPONSE = 702
        public static let CREDIT_CARD_REMOVE_CARD_RESPONSE = 703
        public static let CREDIT_CARD_EDIT_TOKEN = 704
        public static let CREDIT_CARD_VALIDATE_CREDITED_VAUE = 705
        public static let CREDIT_CARD_PENDENT_LIST_RESPONSE = 706
        public static let CREDIT_CARD_CONFIRM_BUTTON_CLICKED = 707
        public static let CREDIT_CARD_CONFIRM_BUTTON_CLICKED_FROM_PAYMENT = 708

        public static let DOC_SENT = 751

        public static let BANK_DELETE_RESPONSE = 801

        public static let PARKING_LIST_RESPONSE = 851
        public static let PARKING_SAVED = 852
        public static let PARKING_REMOVED = 853
        public static let PARKING_CARD_RULE_TYPE_LIST_RESPONSE = 854
        public static let PARKING_CARD_RULE_LIST_RESPONSE = 855
        public static let PARKING_PARKED_CARS_RESPONSE = 856
        public static let PARKING_CARDS_BALANCE_RESPONSE = 857
        public static let PARKING_ACTIVE_CARD_RESPONSE = 858
        public static let PARKING_AVAILABLE_LOCAL_RESPONSE = 859
        public static let PARKING_WARNING_RESPONSE = 860
        public static let PARKING_STATEMENT_RESPONSE = 861
        public static let PARKING_STATEMENT_DETAIL_RESPONSE = 862
        public static let PARKING_HAS_PARKED_VEHICLES_RESPONSE = 863
        public static let PARKING_IS_CONTRACT_ACCEPTED_RESPONSE = 864

        public static let CLICKBUS_SCHEDULE_RESPONSE = 901
        public static let CLICKBUS_SEATS_AVAILABLE_RESPONSE = 902
        public static let CLICKBUS_RESERVE_SEAT_RESPONSE = 903
        public static let CLICKBUS_CANCEL_SEAT_RESPONSE = 904
        public static let CLICKBUS_GET_CITIES_RESPONSE = 905
        public static let CLICKBUS_DOWNLOAD_CITIES_RESPONSE = 906

        public static let PAYMENT_GET_PAYMENTS_PRE_RESPONSE = 951

        public static let DIVIDA_LIST_RESPONSE = 1001
        public static let DIVIDA_SEND_ATTACHED_FILE_RESPONSE = 1002
        public static let DIVIDA_BOLETO_RESPONSE = 1002
        public static let DIVIDA_PAY = 1003
        public static let DIVIDA_GET_TRANSICOES = 1004
        public static let DIVIDA_CAIXA_COMPLEMENT = 1005

        public static let METROCARD_PRODUCTS_RESPONSE = 1011
        public static let METROCARD_BALANCE_RESPONSE = 1012
        
        public static let STUDENT_SCHOOL_LIST_RESPONSE = 1051
        public static let STUDENT_BUS_LINE_LIST_RESPONSE = 1052
        public static let STUDENT_FORM_CONSULT_RESPONSE = 1053
        public static let STUDENT_ADD_OR_EDIT_FORM_RESPONSE = 1054
        public static let STUDENT_GET_FORM_RESPONSE = 1055
        public static let STUDENT_SCHOOL_LIST_UPDATE_REQUIRED = 1056
        
        public static let ADDRESS_CONSULT_CEP_RESPONSE = 1101
        
        public static let TAXA_GET_CARD_RESPONSE = 1102
        public static let TAXA_GET_TYPE_CARD_RESPONSE = 1103
        public static let TAXA_LAYOUT_FORM_RESPONSE = 1104
        public static let TAXA_CREATE_FORM_RESPONSE = 1105
        public static let TAXA_GET_FORM_RESPONSE = 1106
        public static let TAXA_GET_TAXA_RESPONSE = 1107
        public static let TAXA_GET_CAMPO_TAXA_RESPONSE = 1108
        public static let TAXA_GET_FORM_UPDATE = 1109
    }
}
