//
//  Anexo.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class Anexo: BasePojo {
    
    @objc dynamic var type: Int = 0
    @objc dynamic var path: String = ""
    var url: URL?
    @objc dynamic var tag: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {

        type <- map["id_tipo_arquivo"]
        tag <- map["tag"]
    }
    
    convenience init(type: Int, path: String, tag: String) {
        self.init()
        
        self.type = type
        self.path = path
        self.tag = tag
    }
    
    convenience init(type: Int, tag: String) {
        self.init()
        
        self.type = type
        self.tag = tag
    }
    
    convenience init(type: Int, url: URL, tag: String) {
        self.init()
        
        self.type = type
        self.url = url
        self.tag = tag
    }
}
