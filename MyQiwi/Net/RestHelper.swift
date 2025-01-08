//
//  RestHelper.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import ObjectMapper

class RestHelper {

    typealias Object = BasePojo

    // Fill the service response and returns the data object as a json
    static func fillServiceResponse<T:BasePojo>(_ type: T.Type, serviceObject: Object, serviceResponse: ServiceResponse<T>) -> String {
        return ""
    }
    
    // Verify the S attribute
    static func setS(serviceResponse: ServiceResponse<InitializationResponse>) -> Bool {
        
        let a = serviceResponse.body?.data?.s ?? ""
        let t = serviceResponse.header?.terminalId ?? 0
        let s = serviceResponse.header?.seq ?? 0
        
        // Campo espefico no "a"
        
        return SQiwi.sS(a: a, t: t, s: s) == 0
    }
    
    // Verify if T is valid to continue
    static func setT(a: String, header: BodyHeaderResponse?) -> Bool {
        
        // A: String
        
        let t = header?.terminalId ?? 0
        let s = header?.seq ?? 0
        
        return SQiwi.sT(a: a, t: t, s: s) == 0
    }
    
    static func getQiwiPW(pass: String, seq: Int) -> String {
        let tel = UserDefaults.standard.string(forKey: PrefsKeys.PREFS_USER_CEL)
        let t = BaseRN.getTerminalId()
     
        return SQiwi.cS(a: pass, b: tel!, t: Int(t)!, s: seq)
    }
    
    // Check if a response is valid to pass. If isn't valid, the request must not be processed.
    static func verifyResponse(response: ServiceResponseDataInt) -> Bool {
        
        guard let body = response.body else {
            return false
        }
        
        if response.body == nil {
            return false
        }
        
        return verifyResponse(BodyResponseDataInt.self, dataObject: body, headerObject: response.header ?? BodyHeaderResponse())
    }
    
    // Check if a response is valid to pass. If isn't valid, the request must not be processed.
    static func verifyResponse(response: ServiceResponseDataString) -> Bool {
        
        guard let body = response.body else {
            return false
        }
        
        if response.body == nil {
            return false
        }
        
        return verifyResponse(BodyResponseDataString.self, dataObject: body, headerObject: response.header ?? BodyHeaderResponse())
    }
    
    // Check if a response is valid to pass. If isn't valid, the request must not be processed.
    static func verifyResponse(response: ServiceResponseDataBool) -> Bool {
        
        guard let body = response.body else {
            return false
        }
        
        if response.body == nil {
            return false
        }
        
        return verifyResponse(BodyResponseDataBool.self, dataObject: body, headerObject: response.header ?? BodyHeaderResponse())
    }
    
    // Check if a response is valid to pass. If isn't valid, the request must not be processed.
    static func verifyResponse(response: ServiceResponseWithJson) -> Bool {
        
        guard let body = response.body else {
            return false
        }
        
        if response.body == nil {
            return false
        }
        
        return verifyResponse(BodyResponseWithJson.self, dataObject: body, headerObject: response.header ?? BodyHeaderResponse())
    }
    
    // Check if a response is valid to pass. If isn't valid, the request must not be processed.
    static func verifyResponse<T:BasePojo>(_ type: T.Type, response: ServiceResponse<T>?) -> Bool {
        
        guard let response = response else {
            return false
        }
        
        guard let body = response.body else {
            return false
        }
        
        if response.body == nil {
            return false
        }
        
        // Batismo não validar F
        if !(T.self is BaptismResponse.Type) {
            
            //If has no f, will be the baptism that has no f
            guard let f = response.header?.f else {
                return false
            }
            
            //If has no f, will be the baptism that has no f
            if !f.isEmpty {
                return true
            }
        }
        
        return verifyResponse(BodyResponse<T>.self, dataObject: body, headerObject: response.header ?? BodyHeaderResponse())
    }
    
    // Check if a response is valid to pass. If isn't valid, the request must not be processed.
    static func verifyResponse<T:BasePojo>(_ type: T.Type, response: ServiceResponseList<T>?) -> Bool {
        
        guard let response = response else {
            return false
        }
        
        guard let body = response.body else {
            return false
        }
        
        if response.body == nil {
            return false
        }
        
        // Batismo não validar F
        if !(T.self is BaptismResponse.Type) {
            
            //If has no f, will be the baptism that has no f
            guard let f = response.header?.f else {
                return false
            }
            
            //If has no f, will be the baptism that has no f
            if !f.isEmpty {
                return true
            }
        }
        
        let header = BodyHeaderResponse()
        header.f = response.header?.f!
        header.seq = response.header?.seq ?? 0
        header.terminalId = response.header?.terminalId ?? 0
        return verifyResponse(BodyResponseList<T>.self, dataObject: body, headerObject: header)
    }
    
    // Check if a response is valid to pass. If isn't valid, the response must not be processed.
    static func verifyResponse<T:BasePojo>(_ type: T.Type, dataObject: T, headerObject: BodyHeaderResponse) -> Bool {
        
        let a = dataObject.toJSONString() ?? ""
        let t = headerObject.terminalId
        let s = headerObject.seq
        let f = headerObject.f
        
        // Usar body no "a"
        
        return SQiwi.vA(a: a, t: t, s: s, f: f ?? "") == 0
    }
    
    // Check if a request is valid to pass. If isn't valid, the request must not be processed.
    static func verifyObject<T:BasePojo>(_ type: T.Type, dataObject: [T]?, headerObject: BodyHeader) -> String {
        
        let a = dataObject?.toJSONString() ?? ""
        let t = Int(headerObject.terminalId) ?? -1
        let s = headerObject.seq
        
        // Usar body no "a"
        
        let jsonString = SQiwi.cA(a: a, t: t, s: s)
        Log.print("\n body: \(a), codterminal: \(t), sequencia: \(s)")
        Log.print(jsonString, typePrint: .alert)
        
        // Retorna conteudo da key "F"
        
        return jsonString
    }
    
    // Check if a request is valid to pass. If isn't valid, the request must not be processed.
    static func verifyObject<T:BasePojo>(_ type: T.Type, dataObject: T?, headerObject: BodyHeader) -> String {
        
        let a = dataObject?.toJSONString() ?? ""
        let t = Int(headerObject.terminalId) ?? -1
        let s = headerObject.seq
        
        // Usar body no "a"
        
        let jsonString = SQiwi.cA(a: a, t: t, s: s)
        Log.print("\n body: \(a), codterminal: \(t), sequencia: \(s)")
        Log.print(jsonString, typePrint: .alert)
        
        // Retorna conteudo da key "F"
        
        return jsonString
    }
    
    // Check if a request is valid to pass. If isn't valid, the request must not be processed.
    // Manualy JSON for Framework and Server Sync parsing
    static func verifyObject(dataObject: InitializationBody, headerObject: BodyHeader) -> String {
        
        let bodyString = "{\"versao_so\":\"\(dataObject.iosVersion)\",\"versao_app\":\"\(dataObject.appVersion)\",\"municipio\":\"\(dataObject.city)\",\"device_token\":\"\(dataObject.deviceToken)\"}"
        
        let a = bodyString
        let t = Int(headerObject.terminalId) ?? -1
        let s = headerObject.seq
        
        // Usar body no "a"
        
        Log.print("body Framework: \n\(a) \n", typePrint: .alert)
        
        let jsonString = SQiwi.cA(a: a, t: t, s: s)
        Log.print(jsonString, typePrint: .alert)
        
        // Retorna conteudo da key "F"
        
        return jsonString
    }
    
    // Check if a request is valid to pass. If isn't valid, the request must not be processed.
    // Manualy JSON for Framework and Server Sync parsing
    static func verifyJsonObject(dataObject: Data, headerObject: BodyHeader) -> String {
        let string = String(data: dataObject, encoding: .utf8)
        return RestHelper.verifyJsonObject(dataObject: string != nil ? string! : "", headerObject: headerObject)
    }
    
    // Check if a request is valid to pass. If isn't valid, the request must not be processed.
    // Manualy JSON for Framework and Server Sync parsing
    static func verifyJsonObject(dataObject: String, headerObject: BodyHeader) -> String {
        
        
        let t = Int(headerObject.terminalId) ?? -1
        let s = headerObject.seq
        
        Log.print("body Framewotmk: \n\(dataObject) \n", typePrint: .alert)
        
        let jsonString = SQiwi.cA(a: dataObject, t: t, s: s)
        Log.print(jsonString, typePrint: .alert)
        
        // Retorna conteudo da key "F"
        return jsonString
    }
    
    static func jsonStringToData(jsonString: String) -> Data {
        var data: Data = Data()
        
        // Extract optional
        data = jsonString.data(using: .utf8, allowLossyConversion: false)!
        
        if let jsonString = String(data: data, encoding: .utf8) {
            Log.print("String to data convertion: \n\(jsonString)", typePrint: .alert)
        }
        
        return data
    }
}
