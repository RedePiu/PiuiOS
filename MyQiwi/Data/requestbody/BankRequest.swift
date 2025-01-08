
//
//  BankRequest.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

//import RealmSwift
import ObjectMapper

class BankRequest: BasePojo {

    @objc dynamic var appId: Int = 0
    @objc dynamic var serverpk: Int = 0
    @objc dynamic var bankId: Int = 0
    @objc dynamic var ownerName: String = ""
    @objc dynamic var ownerAgency: String = ""
    @objc dynamic var ownerAccount: String = ""
    @objc dynamic var ownerAccountDigit: String = ""
    @objc dynamic var nickname: String = ""
    @objc dynamic var cpf: String = ""
    @objc dynamic var save: Bool = false
    
    public override static func primaryKey() -> String? {
        return "appId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        
        serverpk <- map["id_agrupador_usuario"]
        bankId <- map["id_banco"]
        ownerAgency <- map["agencia"]
        ownerAccount <- map["conta"]
        ownerAccountDigit <- map["conta_dv"]
        ownerName <- map["nome"]
        cpf <- map["cpf"]
        nickname <- map["apelido"]
        save <- map["salvar"]
    }
}
