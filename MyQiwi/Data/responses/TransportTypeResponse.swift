//
//  TransportTypeResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class TransportTypeResponse: BasePojo {

    @objc dynamic var code: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var maxAmount: Double = 0
    @objc dynamic var minAmount: Double = 0
    @objc dynamic var unitValue: Double = 0
    var tipo: Tipo?
    
    enum Tipo: Int {
        case COMUM = 1
        case ESTUDANTE = 2
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        code <- map["codigo"]
        desc <- map["descricao"]
        maxAmount <- map["qtdeMaxima"]
        minAmount <- map["QtdeMinima"]
        unitValue <- map["valorUnitario"]
        
        if let tipoResponse = map["tipo"].currentValue as? Int {
            switch tipoResponse {
            case 1:
                tipo = Tipo.COMUM
                break
            case 2:
                tipo = Tipo.ESTUDANTE
                break
            default:
                break
            }
        }
    }
}

extension TransportTypeResponse {
    
    func getData() -> Data? {
        return nil
    }
}


