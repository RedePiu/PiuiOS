//
//  DocumentProcess.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class DocumentProcess: BasePojo {

    @objc dynamic var processId: Int = 0
    @objc dynamic var status: Int = 0
    @objc dynamic var seen: Bool = false
    @objc dynamic var cardNumber: String = ""
    var documents: [DocumentImage] = []
    
    override public static func primaryKey() -> String? {
        return "processId"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        processId <- map["id_documento_processos"]
        status <- map["status"]
        seen <- map["visualizado"]
        cardNumber <- map["numerocartao"]
        documents <- map["documentos"]
    }
}
