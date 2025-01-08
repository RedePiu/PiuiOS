//
//  CreditCard.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class CreditCard: BasePojo {

    @objc dynamic var cardNumber: String = ""
    @objc dynamic var ownerName: String = ""
    @objc dynamic var validate: String = ""
    @objc dynamic var cvv: String = ""
    @objc dynamic var stringBrand: String = ""
    @objc dynamic var saveCard: Bool = false
    var documents: [DocumentImageRequest] = []
    var image: UIImage?
    @objc dynamic var brand: Int = 0
    @objc dynamic var nickname: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cardNumber <- map["numCartao"]
        ownerName <- map["titular"]
        validate <- map["expiracao"]
        cvv <- map["codSeguranca"]
        stringBrand <- map["bandeira"]
        saveCard <- map["gravarCartao"]
        documents <- map["documentos"]
        image <- map["image"]
        brand <- map["brand"]
        nickname <- map["apelido"]
    }
    
    convenience init(brand: Int, cardNumber: String) {
        self.init()
        
        self.brand = brand
        self.cardNumber = cardNumber
    }
}

extension CreditCard {
    
    func setBrand(brand: Int) {
        
        self.brand = brand
        
        if brand == ActionFinder.CreditCard.BRAND_MASTER {
            stringBrand = "Master"
        }
        else if brand == ActionFinder.CreditCard.BRAND_VISA {
            stringBrand = "Visa"
        }
        else if brand == ActionFinder.CreditCard.BRAND_ELO {
            stringBrand = "Elo"
        }
    }
    
    func getLastFourNumbers() -> String {
        return cardNumber.isEmpty ? "" : cardNumber[(cardNumber.count - 4)..<cardNumber.count]
    }
    
    func getCardExpiryMonth() -> Int {
        if !self.validate.isEmpty {
            return Int(self.validate.substring(0, 2)) ?? 0
        }
        return 0
    }
    
    func getCardExpiryYear() -> Int {
        if !self.validate.isEmpty {
            return Int(self.validate.substring(4)) ?? 0
        }
        return 0
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateDocumentArrayJson() -> String {
        var json = "["
        
        for i in 0..<self.documents.count {
            json += self.documents[i].generateJsonBodyAsString()
            
            if i < self.documents.count - 1 {
                json += ","
            }
        }
        
        json += "]"
        return json
    }
    
//    {"numCartao":"4593150210830194","codSeguranca":"053","documentos":[{"tag_bucket":"1bc0d3c6a19df2238a755f8c05e7f022","id":0,"id_imagem":"1249109012019155603.jpg","tipo":4}],"titular":"AILTON RAMOS","bandeira":"Visa","expiracao":"01/2026"}
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"apelido\":\"\(self.nickname)\",\"numCartao\":\"\(self.cardNumber)\",\"codSeguranca\":\"\(self.cvv)\",\"documentos\":\(self.generateDocumentArrayJson()),\"titular\":\"\(self.ownerName)\",\"bandeira\":\"\(self.stringBrand)\",\"expiracao\":\"\(self.validate)\"}"
        return bodyString
    }
}
