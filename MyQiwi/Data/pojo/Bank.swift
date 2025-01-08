//
//  Bank.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper
//import RealmSwift

class Bank: BasePojo {

    @objc dynamic var id: Int = 0
    @objc dynamic var febranCode: String = ""
    @objc dynamic var bankName: String = ""
    @objc dynamic var agency: String = ""
    @objc dynamic var account: String = ""
    @objc dynamic var accoutDigit: String = ""
    @objc dynamic var ownerName: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["Id_Banco"]
        febranCode <- map["Cd_Febraban"]
        bankName <- map["NomeBanco"]
        agency <- map["Agencia"]
        account <- map["Conta"]
        accoutDigit <- map["Conta_DV"]
        ownerName <- map["Nome"]
    }
}
