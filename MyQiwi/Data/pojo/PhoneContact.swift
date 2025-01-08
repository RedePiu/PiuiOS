//
//  PhoneContact.swift
//  MyQiwi
//
//  Created by ailton on 03/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper
//import RealmSwift

public class PhoneContact: BasePojo {
    
    @objc dynamic var appid: Int = 0
    @objc dynamic var serverpk: Int = 0
    @objc dynamic var number: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var ddd: String = ""
    @objc dynamic var photo: String?
    @objc dynamic var op: String?
    
    override public static func primaryKey() -> String? {
        return "number"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        serverpk <- map["id_agrupador_usuario"]
        number <- map["numero"]
        name <- map["apelido"]
        ddd <- map["ddd"]
        photo <- map["photo"]
        op <- map["operadora"]
    }

    convenience init(name: String, ddd: String, number: String) {
        self.init()
        
        self.name = name
        self.ddd = ddd
        self.number = number
    }
    
    convenience init(name: String, ddd: String, number: String, photo: String) {
        self.init()
        
        self.name = name
        self.ddd = ddd
        self.number = number
        self.photo = photo
    }
    
    convenience init(appId: Int, serverPk: Int, name: String, ddd: String, number: String, photo: String?, op: String?) {
        self.init()
        
        self.appid = appId
        self.serverpk = serverPk
        self.name = name
        self.ddd = ddd
        self.number = number
        self.photo = photo
        self.op = op
    }
    
//    public override var hashValue: Int {
//        return self.ddd.hashValue ^ self.number.hashValue
//    }
//
//    public override static func == (lhs: PhoneContact, rhs: PhoneContact) -> Bool {
//        return lhs.ddd == rhs.ddd && lhs.number == rhs.number
//    }
}
