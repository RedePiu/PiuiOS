//
//  CouponProduct.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper
import RealmSwift

public class CouponProduct: BasePojo {
    
//    string cod_cupom,
//    DateTime validade
//    decimal valor
//    produtos:
//    [
//       int id_prv,
//       string nome
//    ]
    
    @objc dynamic var id: Int = 0
    @objc dynamic var couponCode: String = ""
    @objc dynamic var prvid: Int = 0
    @objc dynamic var name: String = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        prvid <- map["id_prv"]
        name <- map["nome"]
    }
    
    convenience init(prvid: Int, name: String) {
        self.init()
        
        self.prvid = prvid
        self.name = name
    }
}
