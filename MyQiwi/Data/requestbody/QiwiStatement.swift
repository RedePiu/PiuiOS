//
//  QiwiStatement.swift
//  MyQiwi
//
//  Created by Ailton on 12/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class QiwiStatement : BasePojo {
    
    @objc dynamic var fromDate : String = ""
    @objc dynamic var toDate : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        fromDate <- map["data_inicio"]
        toDate <- map["data_fim"]
    }
    
    convenience init(fromDate: String, toDate: String) {
        self.init()
        
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    func generateJsonBody() -> Data {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        var data: Data = Data()
        
        // Extract optional
        let bodyString = "{\"data_inicio\":\"\(self.fromDate)\",\"data_fim\":\"\(self.toDate)\"}"
        data = bodyString.data(using: .utf8, allowLossyConversion: false)!
        
        if let jsonString = String(data: data, encoding: .utf8) {
            Log.print("Body Data Request \(InitializationBody.self): \n\(jsonString)", typePrint: .alert)
        }
        
        return data
    }
    
    static func generateServiceJson(_ body: ServiceBody<QiwiStatement>) -> Data? {
        
        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>
        
        var data: Data? = nil
        
        // Extract optional
        if let bodyData = body.data {
            
            let bodyString = "{\"body\":{\"data_inicio\":\"\(bodyData.fromDate)\",\"data_fim\":\"\(bodyData.toDate)\"},\"header\":{\"f\":\"\(body.header?.f)\",\"sequencial\":\(body.header?.seq),\"codterminal\":\"\(body.header?.terminalId)\"}}"
            
            data = bodyString.data(using: .utf8, allowLossyConversion: false)
            
            if let data = data {
                
                if let jsonString = String(data: data, encoding: .utf8) {
                    Log.print("Body Data Request \(InitializationBody.self): \n\(jsonString)", typePrint: .alert)
                }
            }
        }
        
        return data
    }
}
