//
//  ServiceResponseWithJson.swift
//  MyQiwi
//
//  Created by Ailton on 25/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class ServiceResponseWithJson: BasePojo  {
    
    @objc dynamic var header: BodyHeaderResponse? = BodyHeaderResponse()
    @objc dynamic var body: BodyResponseWithJson? = nil
    @objc dynamic var sucess: Bool = false
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        header <- map["header"]
        body  <- map["body"]
    }
    
    convenience init(header: BodyHeaderResponse?, body: BodyResponseWithJson?) {
        self.init()
        
        self.header = header
        self.body = body
    }
}

public class BodyResponseWithJson: BasePojo {
    
    @objc dynamic var cod: Int = 0
    var messages: [String] = []
    @objc dynamic var data: String? = nil
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        cod <- map["codigo"]
        messages <- map["mensagem"]
        data <- map["data"]
    }
    
    convenience init(cod: Int, messages: [String], data: String) {
        self.init()
        
        self.cod = cod
        self.messages = messages
        self.data = data
    }
    
    public func showMessages() -> String {
        
        if messages.isEmpty {
            return ""
        }
        
        var returnedMessage = ""
        for message in messages.enumerated() {
            returnedMessage.append(message.element)
            
            if message.offset < messages.count - 1 {
                returnedMessage.append("\n")
            }
        }
        
        return returnedMessage
    }
}
