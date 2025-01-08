//
//  InitializationResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class InitializationResponse: BasePojo {

    @objc dynamic var s: String = ""
    @objc dynamic var p: String = ""
    @objc dynamic var appVersion: Int = 0
    @objc dynamic var isValidateDoc: Bool = true
    @objc dynamic var terminalType: Int = 0
    var menuList: [MenuItem] = []
    var taxes: [Tax]?
    var paymentTypes: [PaymentType]?
    var attendanceQuestions: [AttendanceQuestion]?
    var banks: [Bank]?
    var paymentTypeLimits: [PaymentTypeLimit]?
    var paymentTypeLimitsPrvid: [PaymentTypeLimitPrvId]?
    var incommValues: [IncommValue]?
    var pinofflineValues: [PinofflineValue]?
    var serasaValues: [SerasaValue]?
    var serasaAntiFraudValues: [SerasaAntiFraudValue]?
    var rvValues: [RvValue]?
    var produtoProdata: [ProdutoProdata]?
    @objc dynamic var clickbusVersion: Int = 0
    @objc dynamic var clickbusFileName: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        s <- map["s"]
        p <- map["p"]
        appVersion <- map["versao_app"]
        isValidateDoc <- map["isValidaDocs"]
        terminalType <- map["id_Tipo_Terminal"]
        banks <- map["Banco"]
        menuList <- map["menu"]
        taxes <- map["taxas"]
        paymentTypes <- map["pagamentos"]
        attendanceQuestions <- map["menusChatOnline"]
        paymentTypeLimits <- map["LimiteTipoPagamento"]
        paymentTypeLimitsPrvid <- map["LimiteTipoPagamentoPrvid"]
        incommValues <- map["Incomm"]
        pinofflineValues <- map["PinOffline"]
        serasaValues <- map["Serasa"]
        serasaAntiFraudValues <- map["SerasaAntifraude"]
        rvValues <- map["Rv"]
        produtoProdata <- map["produtoProdata"]
        clickbusVersion <- map["VersaoClickBus"]
        clickbusFileName <- map["NomeArquivoClickBus"]
    }
}
