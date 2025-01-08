//
//  AttendanceTicketConsultingCPFBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class AttendanceTicketConsultingCPFBody : Codable {
    
    @objc dynamic var cpf : String
    
    enum CodingKeys: String, CodingKey {
        case cpf = "cpf"
    }
    
    init() {
        self.cpf = ""
    }
}
