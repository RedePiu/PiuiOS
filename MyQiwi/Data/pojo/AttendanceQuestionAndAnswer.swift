//
//  AttendanceQuestionAndAnswer.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 23/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class AttendanceQuestionAndAnswer: Codable {

    @objc dynamic var question: String
    @objc dynamic var answer: String
    
    enum CondingKeys: String, CodingKey {
        case question = "pergunta"
        case answer = "resposta"
    }
    
    init() {
        self.question = ""
        self.answer = ""
    }
    
    convenience init(question: String, answer: String) {
        self.init()
        
        self.question = question
        self.answer = answer
    }
}
