//
//  RequestClickbus.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 12/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RequestClickbus : BasePojo {
    
    @objc dynamic var sessionId: Int = 0
    @objc dynamic var buyerBirthday: String = ""
    @objc dynamic var buyerDocument: String = ""
    @objc dynamic var buyerEmail: String = ""
    @objc dynamic var buyerFirstName: String = ""
    @objc dynamic var buyerGender: String = ""
    @objc dynamic var buyerLastName: String = ""
    @objc dynamic var locale: String = ""
    @objc dynamic var buyerPhone: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        sessionId <- map["sessionId"]
        buyerBirthday <- map["BuyerBirthday"]
        buyerDocument <- map["BuyerDocument"]
        buyerEmail <- map["BuyerEmail"]
        buyerFirstName <- map["BuyerFirstName"]
        buyerGender <- map["BuyerGender"]
        buyerLastName <- map["BuyerLastName"]
        locale <- map["BuyerLocale"]
        buyerPhone <- map["BuyerPhone"]
    }
}
