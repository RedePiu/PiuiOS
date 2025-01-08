//
//  AttendanceQuestion.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 20/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class AttendanceQuestion: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var action: Int = 0
    @objc dynamic var question: String = ""
    @objc dynamic var answer: String = ""
    var childs = [Int]()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["Id"]
        action <- map["Action"]
        question <- map["Topo"]
        answer <- map["Titulo"]
        childs <- map["Filhos"]
    }
    
    convenience init(id: Int, action: Int, question: String, answer: String) {
        self.init()
        
        self.id = id
        self.action = action
        self.question = question
        self.answer = answer
    }
    
    convenience init(action: Int) {
        self.init()
        
        self.action = action
    }
}

//class AttendanceQuestionChilds: Object {
//    @objc dynamic var childs: Int = 0
//}
