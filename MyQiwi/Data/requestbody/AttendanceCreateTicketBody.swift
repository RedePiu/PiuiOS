//
//  AttendanceCreateTicketBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class AttendanceCreateTicketBody : Codable {
    
    @objc dynamic var question : String
    var answer : [AttendanceQuestionAndAnswer]
    
    enum CodingKeys: String, CodingKey {
        case question = "duvida"
        case answer = "passos"
    }
    
    init() {
        self.question = ""
        self.answer = []
    }
}
