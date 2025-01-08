//
//  AttendanceRateBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class AttendanceRateBody : Codable {
    
    var answerAndQuestions : [AttendanceQuestionAndAnswer]
    @objc dynamic var rate : Int
    @objc dynamic var ticketId : Int
    
    enum CodingKeys: String, CodingKey {
        case answerAndQuestions = "passos"
        case rate = "Avaliacao"
        case ticketId = "Id_Chamado"
    }
    
    init() {
        self.answerAndQuestions = []
        self.rate = 0
        self.ticketId = 0
    }
}
