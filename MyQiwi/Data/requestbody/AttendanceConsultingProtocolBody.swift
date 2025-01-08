//
//  AttendanceConsultingProtocolBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class AttendanceConsultingProtocolBody : Codable {
    
    @objc dynamic var protocolId : String
    
    enum CodingKeys: String, CodingKey {
        case protocolId = "protocolo"
    }
    
    init() {
        self.protocolId = ""
    }
}
