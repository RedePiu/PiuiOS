//
//  PushResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class PushResponse: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var cod: Int = 0
    @objc dynamic var message: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var contentId: Int = 0
    @objc dynamic var userId: Int = 0
    var data: BasePojo?
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cod <- map["codigo"]
        message <- map["mensagem"]
        date <- map["date"]
        contentId <- map["id_conteudo"]
        data <- map["data"]
    }
}
