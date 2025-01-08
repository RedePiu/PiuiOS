//
//  Message.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 20/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class Message: Codable {
    
    var id: String
    var body: String
    var sender: String
    var receiver: String
    var date: String
    var time: String
    var isMine: Bool
    
    enum CondingKeys: String, CodingKey {
        case id
        case body
        case sender
        case date
        case time
        case isMine
    }
    
    init() {
        self.id = ""
        self.body = ""
        self.sender = ""
        self.receiver = ""
        self.date = ""
        self.time = ""
        self.isMine = false
    }
    
    convenience init(body: String, time: String, isMine: Bool) {
        self.init()
        
        self.body = body
        self.time = time
        self.isMine = isMine
    }
}
