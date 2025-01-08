//
//  DividaTransacoesBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import ObjectMapper

class DividaTransacoesBody : BasePojo {

    @objc dynamic var idDivida : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idDivida <- map["Id_Loja_Endereco_Divida"]
    }
    
    convenience init(idDivida: Int) {
        self.init()
        self.idDivida = idDivida
    }
    
    func generateJsonBody() -> Data {
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        // Extract optional
        let bodyString = "{\"Id_Loja_Endereco_Divida\":\(self.idDivida)}"
        return bodyString
    }
}
