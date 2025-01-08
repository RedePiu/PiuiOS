//
//  QiwiPoint.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/05/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class QiwiPoint: BasePojo {
    
    @objc dynamic var idStoreAddress: Int = 0
    @objc dynamic var type: Int = 0
    @objc dynamic var storeName: String = ""
    @objc dynamic var storeNameAddress: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var neighborhood: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idStoreAddress <- map["id_loja_endereco"]
        type <- map["tipo"]
        storeName <- map["nome_loja"]
        storeNameAddress <- map["nome_loja_endereco"]
        address <- map["endereco"]
        neighborhood <- map["bairro"]
        city <- map["cidade"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
    }
}

