//
//  BillDetailsBody.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper
import Foundation

class BillDetailsBody : BasePojo {
    
    @objc dynamic var isScan : Bool = true
    @objc dynamic var barcode : String = ""
    @objc dynamic var value : Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        isScan <- map["scan"]
        barcode <- map["ipte"]
        value <- map["valorPago"]
    }
    
    convenience init(barcode: String, value: Int, isScan: Bool) {
        self.init()
        
        self.isScan = isScan
        self.barcode = barcode
        self.value = value
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        
        //{"ipte":"23793381286000177383127000063308577310000000500","scan":true,"valorPago":500},
        //{"ipte":"23793381286000177383127000063308577310000000500","scan":true,"valorPago":8600017738},
        
        // Extract optional
        let bodyString = "{\"ipte\":\"\(self.barcode)\",\"scan\":true,\"valorPago\":\(self.value)}"
        return bodyString
    }
}

