//
//  BasePojo.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/11/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper
import RealmSwift

public class BasePojo: Object, Mappable {

    public required convenience init?(map: Map) {
        self.init()
    }
    
    public func mapping(map: Map) {
    }
}
