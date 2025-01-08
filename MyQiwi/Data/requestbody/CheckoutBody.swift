//
//  CheckoutBody.swift
//  MyQiwi
//
//  Created by Ailton on 13/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class CheckoutBody : BasePojo {

    public var requestBill : RequestBillPayment?
    public var requestPhone : RequestPhoneRecharge?
    public var requestInternationalPhone : RequestInternationalPhone?
    public var requestTransport : RequestTransport?
    public var requestTransportCittaMobi : RequestTransportCittaMobi?
    public var requestProdata : RequestProdata?
    public var requestQiwiCharge : QiwiChargeBody?
    @objc dynamic public var transition : Transition? = Transition()
    public var requestIncomm : RequestIncomm?
    public var requestPinoffline : RequestPinoffline?
    public var requestRv : RequestRV?
    public var requestRvSpotify : RequestRVSpotify?
    public var requestSerasaConsult : RequestSerasaConsult?
    public var creditQiwiTransferRequest: CreditQiwiTransferRequest?
    public var requestParking : RequestParking?
    public var requestUrbs : RequestUrbs?
    public var requestQiwiTransferForPrePago : RequestQiwiTransferForPrePago?
    public var requestClickbus : RequestClickbus?
    public var requestMetrocard : RequestMetrocard?
    public var requestDonation : RequestDonation?
    public var requestUltragaz : RequestUltragaz?
    public var requestDrTerapia: RequestDrTerapia?
    public var requestTelesena : RequestTelesena?
    public var requestTaxaCampo : RequestTaxaAdm?

    //public var requestSerasaConsult : requestSerasaConsult

    required convenience init?(map: Map) {
        self.init()
    }

    override func mapping(map: Map) {

        requestBill <- map["pagamento"]
        requestPhone <- map["telefonia"]
        requestInternationalPhone <- map["transferTo"]
        requestTransport <- map["transporte"]
        requestTransportCittaMobi <- map["cittamobi"]
        requestProdata <- map["prodata"]
        requestParking <- map["zonaazul"]
        transition <- map["transacao"]
        requestQiwiCharge <- map["contaqiwi2"]
        requestIncomm <- map["incomm"]
        requestPinoffline <- map["pinoffline"]
        requestRv <- map["rv"]
        requestRvSpotify <- map["rvPin"]
        requestSerasaConsult <- map["serasa"]
        creditQiwiTransferRequest <- map["transferenciacontaqiwi2"]
        requestUrbs <- map["urbs"]
        requestQiwiTransferForPrePago <- map["transferenciaprepago"]
        requestClickbus <- map["ClickBusMobile"]
        requestMetrocard <- map["Metrocard"]
        requestDonation <- map["doacao"]
        requestUltragaz <- map["ultragaz"]
        requestDrTerapia <- map["doutorterapia"]
        requestTelesena <- map["vendaTendenciaTelesena"]
        requestTaxaCampo <- map["taxa"]

        //case requestCreditoAnalysis = "serasaantifraude"
        //case requestSerasaConsult = "serasa"

    }
}
