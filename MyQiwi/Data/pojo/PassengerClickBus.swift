//
//  PassengerClickBus.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper
//import Realm
//import RealmSwift

class PassengerClickBus: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var document: String = ""
    @objc dynamic var documentType: String = ""
    @objc dynamic var documentTypePosition: Int = 0
    
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        name <- map["nome"]
        document <- map["documento"]
        documentType <- map["documentType"]
        documentTypePosition <- map["documentTypePosition"]
    }
    
    convenience init(id: Int, name: String, document: String, documentType: String, documentTypePosition: Int) {
        self.init()
        
        self.id = id
        self.name = name
        self.document = document
        self.documentType = documentType
        self.documentTypePosition = documentTypePosition
    }
    
    convenience init(name: String, document: String, documentType: String, documentTypePosition: Int) {
        self.init()
        
        self.name = name
        self.document = document
        self.documentType = documentType
        self.documentTypePosition = documentTypePosition
    }
    
    func getFirstName() -> String {
        if (self.name.contains("/")) {
            return self.name
        }
        
        let nameSplit = self.name.components(separatedBy: " ")
        return nameSplit[0]
    }
    
    func getLastName() -> String {
               if (self.name.contains("/")) {
            return self.name
        }
        
        let nameSplit = self.name.components(separatedBy: " ")
        return nameSplit[nameSplit.count-1]
    }
}
