//
//  ServiceBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

public class ServiceBody<T>: BasePojo where T: BasePojo {
    
    @objc dynamic var header: BodyHeader? = BodyHeader()
    var data: T?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override public func mapping(map: Map) {
        header <- map["header"]
        data <- map["body"]
    }
    
    convenience init(header: BodyHeader?, data: T?) {
        self.init()
        
        self.header = header
        self.data = data
    }
}

public class ServiceBodyList<T>: BasePojo where T: BasePojo {
    
    var header: BodyHeader? = BodyHeader()
    var data: [T]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override public func mapping(map: Map) {
        header <- map["header"]
        data <- map["body"]
    }
    
    convenience init(header: BodyHeader?, data: [T]?) {
        self.init()
        
        self.header = header
        self.data = data
    }
}
