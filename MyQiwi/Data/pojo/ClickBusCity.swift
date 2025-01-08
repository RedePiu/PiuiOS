//
//  ClickBusCity.swift
//  MyQiwi
//
//  Created by Thyago on 18/11/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper
//import RealmSwift

class ClickBusCity: BasePojo {

    @objc dynamic var id: Int = 0
    @objc dynamic var slug: String = ""
    @objc dynamic var name: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    convenience init(id: Int, slug: String, name: String) {
        self.init()
        
        self.id = id
        self.slug = slug
        self.name = name
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        slug <- map["slug"]
        name <- map["name"]
    }
}

