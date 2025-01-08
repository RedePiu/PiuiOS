//
//  ServiceResponse.swift
//  MyQiwi
//
//  Created by ailton on 16/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

public class ServiceResponseList<T>: BasePojo where T: BasePojo {
    
    @objc dynamic var header: BodyHeaderResponse? = BodyHeaderResponse()
    var body: BodyResponseList<T>? = nil
    @objc dynamic var sucess: Bool = false
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        header <- map["header"]
        body <- map["body"]
    }
    
    convenience init(header: BodyHeaderResponse?, body: BodyResponseList<T>?) {
        self.init()
        
        self.header = header
        self.body = body
    }
}

public class BodyResponseList<T>: BasePojo where T: BasePojo {
    
    @objc dynamic var cod: Int = 0
    var messages: [String] = []
    var data: [T]? = nil
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        cod <- map["codigo"]
        messages <- map["mensagem"]
        data <- map["data"]
    }
    
    convenience init(cod: Int, messages: [String], data: [T]?) {
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

public class ServiceResponse<T>: BasePojo where T: BasePojo {
    
    @objc dynamic var header: BodyHeaderResponse? = BodyHeaderResponse()
    var body: BodyResponse<T>? = nil
    @objc dynamic var sucess: Bool = false
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        header <- map["header"]
        body <- map["body"]
    }
    
    convenience init(header: BodyHeaderResponse?, body: BodyResponse<T>?) {
        self.init()
        self.header = header
        self.body = body
    }
}

public class BodyResponse<T>: BasePojo where T: BasePojo {
    
    @objc dynamic var cod: Int = 0
    var messages: [String] = []
    var data: T? = nil
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        cod <- map["codigo"]
        messages <- map["mensagem"]
        data <- map["data"]
    }
    
     public convenience init(cod: Int, messages: [String], data: T?) {
        self.init()
        self.cod = cod
        self.messages = messages
        self.data = data
    }
    
    public func showMessages() -> String {
        
        if messages.isEmpty {
            return ""
        }
        
        var newMessage = ""
        for message in messages.enumerated() {
            newMessage.append(message.element)
            
            if message.offset < messages.count - 1 {
                newMessage.append("\n")
            }
        }
        
        return newMessage
    }
}
