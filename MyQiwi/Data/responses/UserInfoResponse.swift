

//
//  UserInfoResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class UserInfoResponse: BasePojo {

    var cardTokens: [CreditCardToken] = []
    @objc dynamic var user: User? = User()
    var documents: [DocumentImage] = []
    var processes: [DocumentProcess] = []
    var banks: [BankRequest] = []
    var contacts: [PhoneContact] = []
    var pix: [PIXRequest] = []
    var transportCards: [TransportCard] = []
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cardTokens <- map["cartoes"]
        user <- map["usuario"]
        documents <- map["documentos"]
        processes <- map["analisecartoes"]
        banks <- map["bancos"]
        contacts  <- map["contatos"]
        transportCards  <- map["bilhete"]
        pix <- map["pix"]
    }
}
