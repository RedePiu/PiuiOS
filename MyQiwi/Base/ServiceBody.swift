//
//  ServiceBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

public class ServiceBody<T>: Codable where T : AnyObject, T : Codable {
    
    var header: BodyHeader
    var data: T
    
    enum CodingKeys: String, CodingKey {
        case header
        case data = "body"
    }
    
    init(header: BodyHeader, data: T) {
        self.header = header
        self.data = data
    }
    
}
