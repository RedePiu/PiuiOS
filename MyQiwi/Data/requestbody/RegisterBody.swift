//
//  RegisterBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class RegisterBody: BasePojo {

    @objc dynamic var name: String = ""
    @objc dynamic var phoneNumber: String = ""
    @objc dynamic var cpf: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var birthday: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        name <- map["nome"]
        phoneNumber <- map["num_celular"]
        cpf <- map["cpf"]
        email <- map["email"]
        password <- map["senha"]
        birthday <- map["dt_nascimento"]
    }
    
    //{"body":{"dt_nascimento":"1994-03-27","cpf":"43497458821","email":"ailton.tk@hotmail.com","nome":"Ailton Y","senha":"f3ba6d18eccdae368342205bd8d31e9f1d4ca65645067d12c12ed66ef69f85d0","num_celular":"11988447064"}
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        let formattedDate = DateFormatterQiwi.formatDate(self.birthday, currentFormat: "dd/MM/yyyy", toFormat: DateFormatterQiwi.registerPattern)
        
        // Extract optional
        let bodyString = "{\"dt_nascimento\":\"\(formattedDate ?? "")\",\"cpf\":\"\(self.cpf)\",\"email\":\"\(self.email ?? "")\",\"nome\":\"\(self.name)\",\"senha\":\"\(self.password)\",\"num_celular\":\"\(self.phoneNumber)\"}"
        return bodyString
    }
}
