//
//  DividaRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class DividaRN : BaseRN {

    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getDividas(status: Int, daysBack: Int) {
        
        //let yearsToAdd = -1
        let currentDate = Date()
        
        var dateComponent = DateComponents()
        //dateComponent.year = yearsToAdd
        dateComponent.day = -daysBack
        
        let fromDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        
        getDividas(status: status, fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: currentDate))
    }
    
    func getDividas(status: Int, month: Int, year: Int) {
        
        var dateComponent = DateComponents()
        dateComponent.setValue(month, for: .month)
        dateComponent.setValue(year, for: .year)
        dateComponent.setValue(1, for: .day)
        dateComponent.setValue(0, for: .hour)
        dateComponent.setValue(0, for: .minute)
        dateComponent.setValue(0, for: .second)
        
        var toDateComponent = dateComponent
        toDateComponent.year = 0
        toDateComponent.month = 1 //pula um mes
        toDateComponent.day = -1 //volta 1 dia
        toDateComponent.setValue(0, for: .hour)
        toDateComponent.setValue(0, for: .minute)
        toDateComponent.setValue(0, for: .second)
        
        let fromDate = Calendar.current.date(from: dateComponent)
        let toDate = Calendar.current.date(byAdding: toDateComponent, to: fromDate!)
        
        getDividas(status: status, fromDate: DateFormatterQiwi.formatDate(date: fromDate!), toDate: DateFormatterQiwi.formatDate(date: toDate!))
    }
    
    func getDividas(status: Int, fromDate: String, toDate: String) {
        var dividas = [Divida]()

        // Create request
        let obj = DividaListBody(dateFrom: fromDate, dateTo: toDate, status: status)
        let serviceBody = updateJsonWithHeader(jsonBody: obj.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetDividaList, json: serviceBody)
        
        callApiForList(Divida.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                dividas = (response.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: DividaRN.self, param: Param.Contact.DIVIDA_LIST_RESPONSE,
                             result: response.sucess, object: dividas as AnyObject)
        }
    }
    
    func getTransacoes(idDivida: Int) {
        
        var transacoes = [DividaDetailsResponse]()
        
        // Create request
        let obj = DividaTransacoesBody(idDivida: idDivida)
        let serviceBody = updateJsonWithHeader(jsonBody: obj.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedGetDividaTransacoes, json: serviceBody)
        
        callApiForList(DividaDetailsResponse.self, request: request) { (response) in
            
            //If failed to get the baptism response
            if response.sucess {
                transacoes = (response.body?.data)!
            }
            
            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: DividaRN.self, param: Param.Contact.DIVIDA_GET_TRANSICOES,
                             result: response.sucess, object: transacoes as AnyObject)
        }
    }
    
    func getBoleto(idDivida: Int) {

        // Create request
        let objectData = DividaTransacoesBody(idDivida: idDivida)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedConsultaBoletoDivida, json: serviceBody)
        
        callApiDataString(request: request) { (response) in
            
            self.sendContact(fromClass: DividaRN.self, param: Param.Contact.DIVIDA_BOLETO_RESPONSE, result: response.sucess, object: response.body?.data as AnyObject)
        }
    }
    
    func getPaymentOptions() -> [MenuItem] {
        var menuItens = [MenuItem]()
        
        menuItens.append(MenuItem(description: "dividas_payment_pix".localized, action: ActionFinder.DividaPayments.Menus.PIX, imageMenu: "ic_pix"))
        
        menuItens.append(MenuItem(description: "dividas_payment_transf".localized, action: ActionFinder.DividaPayments.Menus.TRANSFERENCIA, imageMenu: "ic_bank_transfer"))
        
        menuItens.append(MenuItem(description: "dividas_payment_deposito".localized, action: ActionFinder.DividaPayments.Menus.DEPOSITO, imageMenu: "ic_coin"))
        
        menuItens.append(MenuItem(description: "dividas_payment_boleto".localized, action: ActionFinder.DividaPayments.Menus.BOLETO, imageMenu: "ic_barcode"))
        
        return menuItens
    }
    
    func sendCaixaCode(dividaId: Int, caixaCode: String) {
        // Create request
        let objectData = DividaCaixaComplementBody(dividaId: dividaId, complement: caixaCode)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedDividaComplementCaixa, json: serviceBody)
        
        callApi(request: request) { (response) in

            // Mostrar uma tela que não foi possivel, abrir o app
            self.sendContact(fromClass: DividaRN.self, param: Param.Contact.DIVIDA_CAIXA_COMPLEMENT,
                             result: response.sucess)
        }
    }
    
    func payWithTransferencia(bankRequest: BankRequest, divida: Divida, receipts: [DividaReceipt]) {
        
        self.pay(id: ActionFinder.DividaPayments.PayService.TRANSFERENCIA, bankRequest: bankRequest, divida: divida, receipts: receipts, pixRequest: PIXRequest())
    }
    
    func payWithDeposito(bankRequest: BankRequest, divida: Divida, receipts: [DividaReceipt]) {
        
        self.sendToAmazon(id: ActionFinder.DividaPayments.PayService.DEPOSITO, bankRequest: bankRequest, divida: divida, receipts: receipts, pixRequest: PIXRequest())
    }
    
    func payWithPIX(divida: Divida, pixRequest: PIXRequest) {
        
        self.pay(id: ActionFinder.DividaPayments.PayService.PIX, bankRequest: BankRequest(), divida: divida, receipts: [DividaReceipt](), pixRequest: pixRequest)
    }
    
    
    func sendToAmazon(id: Int, bankRequest: BankRequest, divida: Divida, receipts: [DividaReceipt], pixRequest: PIXRequest, partialType: Int = 0, partialValue: Double = 0, reason: String = "", partialAttachments: [Anexo] = [Anexo]()) {
        //Envia para Amazon antes de enviar para o servidor
        DividaMultipleReceiptRNAux(dividaRN: self, id: id, bankRequest: bankRequest, divida: divida, receipts: receipts, pixRequest: pixRequest).sendAnexos()
    }
    
    func pay(id: Int, bankRequest: BankRequest, divida: Divida, receipts: [DividaReceipt], pixRequest: PIXRequest) {

        bankRequest.ownerName = bankRequest.ownerName.removeAllOtherCaracters()
        
        // Create request
        let objectData = DividaPayDepositBody(idDivida: divida.dividaId, idPaymentType: id, value: divida.valueDivida, request: bankRequest, receipts: receipts, pixRequest: pixRequest, partialType: DividaDetailViewController.partialTypeId, partialValue: DividaDetailViewController.partialValue, reason: DividaDetailViewController.partialReason, partialAttachments: DividaDetailViewController.partialAnexos)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedPayDivida, json: serviceBody)
        
        callApi(request: request) { (response) in
            
            self.sendContact(fromClass: DividaRN.self, param: Param.Contact.DIVIDA_PAY, result: response.sucess)
        }
    }
}

class DividaMultipleReceiptRNAux: BaseDelegate {
    
    lazy var amazonRN = AmazonRN(delegate: self)
    var dividaRN: DividaRN
    var receipts = [DividaReceipt]()
    var id: Int
    var bankRequest: BankRequest
    var pixRequest: PIXRequest
    var divida: Divida
    var currentIndex = 0
    var currentAttachIndex = 0
    
    init(dividaRN: DividaRN, id: Int, bankRequest: BankRequest, divida: Divida, receipts: [DividaReceipt], pixRequest: PIXRequest) {
        self.dividaRN = dividaRN
        self.id = id
        self.bankRequest = bankRequest
        self.divida = divida
        self.receipts = receipts
        self.currentIndex = 0
        self.currentAttachIndex = 0
        self.pixRequest = pixRequest
    }
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        if fromClass == AmazonRN.self {
            if param == Param.Contact.DOC_SENT {
                
                if !result {
                    self.dividaRN.delegate?.onReceiveData(fromClass: DividaRN.self, param: Param.Contact.DIVIDA_PAY, result: false, object: nil)
                    return
                }
                
                let objs = object as! [AnyObject]
                let imageId = objs[0] as! String
                //let bucketTag = objs[1] as! String
                
                self.receipts[currentIndex].attaches[currentAttachIndex].tag = imageId
                
                self.currentAttachIndex += 1
                if self.currentAttachIndex >= self.receipts[self.currentIndex].attaches.count {
                    self.currentAttachIndex = 0
                    self.currentIndex += 1
                }
                
                self.sendAnexos()
            }
        }
    }
    
    func sendAnexos() {
        //Alreayd Sent all
        if currentIndex >= self.receipts.count {
            self.dividaRN.pay(id: id, bankRequest: bankRequest, divida: divida, receipts: receipts, pixRequest: pixRequest)
            return
        }
        
        let url = URL(string: self.receipts[currentIndex].attaches[currentAttachIndex].path)
        let fileExtension = url?.pathExtension
        let fileName = FileUtils.generateImageName(terminalId: BaseRN.getTerminalId(), seq: self.dividaRN.getCurrentSequencial(), extension: fileExtension ?? ".jpg")
        
        //send to amazon
        self.amazonRN.writeFile(imageType: 0, image: UIImage.init(contentsOfFile: self.receipts[currentIndex].attaches[currentAttachIndex].path) ?? UIImage(named: "logoqiwi")!, fileName: fileName)
    }
    
    func updateAnexos() {
        
    }
}
