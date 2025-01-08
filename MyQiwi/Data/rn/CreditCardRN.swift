//
//  CreditCardRN.swift
//  MyQiwi
//
//  Created by Ailton on 26/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class CreditCardRN : BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getUserCards() {
        let cards = CreditCardTokenDAO().getAll()
        
        print(cards.count)
        
        // Mostrar uma tela que não foi possivel, abrir o app
        self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_CARD_LIST_RESPONSE,
                         result: !cards.isEmpty, object: cards as AnyObject)
    }
    
    func getPendentCards() {
        var cards = [CreditCardToken]()
        
        let serviceBody = getServiceBody(EmptyObject.self, objectData: EmptyObject())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedPendentCreditCards, object: serviceBody)

        callApiForList(CreditCardToken.self, request: request) { (response) in
            
            if response.sucess {
                cards = response.body?.data ?? [CreditCardToken]()
            }
            
            print(cards.count)
            
            self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_CARD_PENDENT_LIST_RESPONSE, result: response.sucess, object: cards as AnyObject)
        }
    }
    
    func sendCreditCard(creditCard: CreditCard) {
        
        // Create request
        let stringJson = creditCard.generateJsonBodyAsString()
        let serviceBody = updateJsonWithHeader(jsonBody: stringJson)
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedRegisterCreditCard, json: serviceBody)
        var cardNumber = 0
        
        callApiDataInt(request: request) { (response) in
            
            
            if response.sucess {
                UserRN.setNeedToSendDocs(sent: false)
                cardNumber = response.body?.data ?? 0
            }
            
            self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_SEND_CREDITCARD_RESPONSE,
                             result: response.sucess, object: cardNumber as AnyObject)
        }
    }
    
//    func sendVideo() {
//        let amazonRN = AmazonRN(delegate: self)
//        let fileName = FileUtils.generateVideoName(path: self.videoPath!.absoluteString, terminalId: BaseRN.getTerminalId(), seq: self.getCurrentSequencial())
//
//        amazonRN.sendVideo(url: self.videoPath!, fileName: fileName)
//    }
//
//    func sendDoc() {
//        let amazonRN = AmazonRN(delegate: self)
//        let fileName = FileUtils.generateImageName(terminalId: BaseRN.getTerminalId(), seq: self.getCurrentSequencial())
//
//        amazonRN.writeFile(imageType: ActionFinder.Documents.Types.FACE_CARTAO, image: self.creditCard!.image!, fileName: fileName)
//    }
    
    
    /**
     * Remove the credit card token from server.<br><br>
     *
     * It will contact throw Param: CREDIT_CARD_BRAND_LIST_RESPONSE
     */
    public func editToken(cardNumber: Int, nickname: String) {
        
        // Create request
        let objectData = EditCreditCardBody(cardNumber: String(cardNumber), nickname: nickname)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedEditCreditCard, json: serviceBody)

        callApi(request: request) { (response) in

            //se removeu do server, removemos do banco
//            if response.sucess {
//                UserRN(delegate: self.delegate).updateUser(completion: { result in
//
//                    self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_CARD_EDIT_TOKEN, result: response.sucess, object: response)
//                })
//                return
//            }

            self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_CARD_EDIT_TOKEN,
                             result: response.sucess, object: (response.body?.data as AnyObject) )
        }
    }
    
    /**
     * Remove the credit card token from server.<br><br>
     *
     * It will contact throw Param: CREDIT_CARD_BRAND_LIST_RESPONSE
     */
    public func removeCardAppId(token: Int) {
        
        // Create request
        let objectData = RemoveCreditTokenBody(tokenId: token)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.toJSONString() ?? "")
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedRemoveToken, json: serviceBody)
        
        callApi(request: request) { (response) in
            
            //se removeu do server, removemos do banco
            if response.sucess {
                let token = CreditCardTokenDAO().get(tokenId: token)
                CreditCardTokenDAO().delete(with: token)
            }
            
            self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_CARD_REMOVE_CARD_RESPONSE,
                             result: response.sucess, object: (response.body?.data as AnyObject) )
        }
    }
    
    public func validateCreditedValue(cardNumber: String, value: Int) {
        
        // Create request
        let objectData = ValidateCreditedValueBody(cardNumber: cardNumber, value: value)
        let serviceBody = updateJsonWithHeader(jsonBody: objectData.generateJsonBodyAsString())
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedValidateCreditedValue, json: serviceBody)
        
        
        callApiDataBool(request: request) { (response) in
            
            var result = false
            
            //se removeu do server, removemos do banco
            if response.sucess {
                result = response.body?.data ?? false
            } else {
                response.body?.data = false
            }
            
            self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_CARD_VALIDATE_CREDITED_VAUE,
                             result: result, object: (response as AnyObject) )
        }
    }
}

extension CreditCardRN : BaseDelegate {
    
    //AuthenticatedRegisterDocument
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
//        if fromClass == AmazonRN.self {
//
//            //Se deu certo, envia o cartao pro servidor
//            if param == Param.Contact.DOC_SENT {
//
//                if !result {
//                    self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_SEND_CREDITCARD_RESPONSE,
//                                     result: false, object: nil)
//                    return
//                }
//
//                let objs = object as! [AnyObject]
//                let imageId = objs[0] as! String
//                let bucketTag = objs[1] as! String
//                let imageType = objs[2] as! Int
//                self.creditCard!.documents.append(DocumentImageRequest(imageType: imageType, imageId: imageId, bucketTag: bucketTag))
//
//                self.sendCreditCardAfterSendImage()
//            }
//
//            //Primeiro vai enviar o video. Se algo der errado, informara para a view controller
//            if param == Param.Contact.DOCS_SEND_VIDEO_RESPONSE {
//
//                if !result {
//                    self.sendContact(fromClass: CreditCardRN.self, param: Param.Contact.CREDIT_SEND_CREDITCARD_RESPONSE,
//                                     result: false, object: nil)
//                    return
//                }
//
//                let objs = object as! [AnyObject]
//                let imageId = objs[0] as! String
//                let bucketTag = objs[1] as! String
//                let imageType = objs[2] as! Int
//                self.creditCard!.documents.append(DocumentImageRequest(imageType: imageType, imageId: imageId, bucketTag: bucketTag))
//
//                //Se deu certo, envia o documento pra amazon
//                self.sendDoc()
//            }
//        }
    }
}
