//
//  MessageRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 23/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

protocol MessageDelegate {
    
    func t()
}

class MessageRN: BaseRN {

    fileprivate func generateMessageId() -> String {
        return "1"
    }
    
    func sendMessage(message: String) -> Message {
        
        let userMessage = Message()
        userMessage.id = generateMessageId()
        userMessage.body = message
        userMessage.time = Util.stringHoursSeconds()
        userMessage.date = Util.stringDate()
        userMessage.isMine = true
        
        // Delay reposta message
        
        
        return userMessage
    }
    
    func getDefaultIntroMessage() -> Message {
        
        let userMessage = Message()
        userMessage.id = generateMessageId()
        userMessage.body = "attendance_robot_default_message".localized
        userMessage.time = Util.stringHoursSeconds()
        userMessage.date = Util.stringDate()
        userMessage.isMine = false
        
        return userMessage
    }
    
    func getCommonQuestions() -> [String] {
        
        let array = ["attendance_common_questions_1",
                     "attendance_common_questions_2",
                     "attendance_common_questions_3",
                     "attendance_common_questions_4"]
        return array
    }
}
