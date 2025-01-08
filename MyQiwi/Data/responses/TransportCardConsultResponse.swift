//
//  TransportCardConsultBody.swift
//  MyQiwi
//
//  Created by Ailton on 13/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class TransportCardConsultResponse : Codable {
    
    @objc dynamic var cardNumber : String
    
    enum CodingKeys: String, CodingKey {
        case cardNumber = "id_cartao"
    }
    
    init() {
        self.cardNumber = ""
    }
}
