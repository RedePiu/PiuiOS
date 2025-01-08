//
//  ServiceListResponse.swift
//  MyQiwi
//
//  Created by Ailton on 04/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

public class ServiceListResponse<T>: Codable where T: Sequence, T: Codable {
    
    var header: BodyHeaderResponse
    var body: BodyServiceResponse<T>?
    var sucess: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case header
        case body
    }
    
    init(header: BodyHeaderResponse, body: BodyServiceResponse<T>?) {
        self.header = header
        self.body = body
    }
}

public class BodyServiceResponse<T>: Codable where T: AnyObject, T: Codable {
    
    var cod: Int
    var messages: [String]
    var data: [T]?
    
    enum CodingKeys: String, CodingKey {
        case cod = "codigo"
        case messages = "mensagem"
        case data
    }
    
    init(cod: Int, messages: [String], data: [T]?) {
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
