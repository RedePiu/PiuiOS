//
//  TransportCardBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class TransportCardBody : Codable {
    
    var serverpk : Int
    var number : String
    var name : String
    
    enum CodingKeys: String, CodingKey {
        case serverpk = "id_agrupador_usuario"
        case number = "numerobilhete"
        case name = "apelido"
    }
    
    init() {
        self.serverpk = 0
        self.number = ""
        self.name = ""
    }
    
    init(transporCard: TransportCard) {
        self.serverpk = transporCard.serverpk
        self.number = transporCard.number
        self.name = transporCard.name
    }
}
