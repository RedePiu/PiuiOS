//
//  BodyHeader.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class BodyHeader: Codable {
    
    var terminalId: String
    var seq: Int
    var f: String
    
    enum CodingKeys: String, CodingKey {
        case terminalId = "codterminal"
        case seq = "sequencial"
        case f = "f"
    }
    
    init() {
        self.terminalId = ""
        self.seq = 0
        self.f = ""
    }
}
