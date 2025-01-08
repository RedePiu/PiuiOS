//
//  TransportCard.swift
//  MyQiwi
//
//  Created by ailton on 18/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import ObjectMapper

public class TransportCard: BasePojo {
    
    @objc dynamic var serverpk: Int = 0
    @objc dynamic var number: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var type: Int = 0
    @objc dynamic var cpf: String = ""
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    override public static func primaryKey() -> String? {
        return "number"
    }
    
    public override func mapping(map: Map) {
        serverpk <- map["id_agrupador_usuario"]
        number <- map["numerobilhete"]
        name <- map["apelido"]
        type <- map["tipo_transporte"]
        cpf <- map["cpf"]
    }
    
    convenience init(number: String, name: String) {
        self.init()
        
        self.number = number
        self.name = name
    }
    
    convenience init(number: String, name: String, cpf: String) {
        self.init()
        
        self.number = number
        self.name = name
        self.cpf = cpf
    }
    
    convenience init(number: String, name: String, type: Int) {
        self.init()
        
        self.number = number
        self.name = name
        self.type = type
    }
    
    convenience init(number: String, name: String, type: Int, cpf: String) {
        self.init()
        
        self.number = number
        self.name = name
        self.type = type
        self.cpf = cpf
    }
    
    convenience init(serverpk: Int, number: String, name: String, type: Int, cpf: String) {
        self.init()
        
        self.serverpk = serverpk
        self.number = number
        self.name = name
        self.type = type
        self.cpf = cpf
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        var bodyString = "{\"apelido\":\"\(self.name )\",\"numerobilhete\":\"\(self.number)\",\"tipo_transporte\":\(self.type),\"cpf\":\"\(self.cpf)\""
        
        if self.serverpk > 0 {
            bodyString += ",\"id_agrupador_usuario\":\(self.serverpk)}"
        } else {
            bodyString += "}"
        }
        
        // ultima ordem funcionando {"bilhete":{"id_agrupador_usuario":0,"numerobilhete":530942970,"apelido":"kkkk"}}
        return bodyString
    }
}
