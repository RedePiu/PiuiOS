//
//  TaxaCardResponse.swift
//  MyQiwi
//
//  Created by Daniel Catini on 05/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import ObjectMapper

class TaxaCardResponse: BasePojo {

    @objc dynamic var cliente: String = ""
    @objc dynamic var cartao: String = ""
    @objc dynamic var codCarga: Int = 0
    var tipo: MenuCardTypeResponse? = MenuCardTypeResponse()
    
    override public static func primaryKey() -> String? {
        return "codCarga"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        cliente <- map["CLIENTE"]
        cartao <- map["CARTAO"]
        codCarga <- map["TIPO"]
    }
}

extension TaxaCardResponse {
    
    func getData() -> Data? {
        return nil
    }
}

