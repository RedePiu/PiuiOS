//
//  RestApi.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 30/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class RestApi {
    
    var task: URLSessionDataTask?
    
    func execute(_ request: URLRequest) -> (Data?, Error?) {
        
        var dataResponse: Data? = nil
        var errorResponse: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        
        self.sessionStart(request) { (data, urlResponse, error) in
            
            if let err = error {
                
                let nsError = (err as NSError)
                
                // Timeout
                if nsError.code == NSURLErrorTimedOut {
                    Log.print("Timeout", typePrint: .warning)
                    Log.print(err.localizedDescription, typePrint: .warning)
                }
                
                errorResponse = err
                
                dispatchSemaphore.signal()
                return
            }
            
            dataResponse = data
            
            dispatchSemaphore.signal()
        }
        
        dispatchSemaphore.wait()
        
        return (dataResponse, errorResponse)
    }
    
    func execute(_ request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
        self.sessionStart(request) { (data, urlResponse, error) in
            
            if let err = error {
                
                let nsError = (err as NSError)
                
                // Timeout
                if nsError.code == NSURLErrorTimedOut {
                    Log.print("Timeout", typePrint: .warning)
                    Log.print(err.localizedDescription, typePrint: .warning)
                }
            }
            
            completion(data, error)
        }
    }
    
    private func sessionStart(_ request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task?.resume()
    }
    
    func generedRequestWithoutBody(url: URL, httpBody: Data) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(integerLiteral: 30)
        
        request.httpBody = httpBody
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [:]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func generedRequestPost<T: BasePojo>(url: URL, object: ServiceBody<T>) -> URLRequest {
        
        return generedRequestWithoutBody(url: url, httpBody: getHttpBody(header: object.header ?? BodyHeader(), body: object.data!)!)
    }
    
    func generedRequestPost<T: BasePojo>(url: URL, object: ServiceBodyList<T>) -> URLRequest {
        
        return generedRequestWithoutBody(url: url, httpBody: getHttpBody(header: object.header ?? BodyHeader(), body: object.data!)!)
    }
    
    func generedRequestPost(url: URL, json: Data) -> URLRequest {
        
        return generedRequestWithoutBody(url: url, httpBody: json)
    }
    
    func generedRequestPost(url: URL, jsonString: String) -> URLRequest {
        
        return generedRequestWithoutBody(url: url, httpBody: RestHelper.jsonStringToData(jsonString: jsonString))
    }
    
    private func getHttpBody<T: BasePojo>(body: T) -> Data? {
        
        let jsonString = body.toJSONString()
        Log.print("Body Request \(T.self): \n\(String(describing: jsonString))", typePrint: .alert)
        
        return jsonString?.data(using: .utf8)
    }
    
    private func getHttpBody<T: BasePojo>(header: BodyHeader, body: T) -> Data? {
        
        let jsonHeader = header.toJSONString()
        let jsonBody = body.toJSONString()
        
        let json = "{\"body\":\(jsonBody ?? ""),\"header\":\(jsonHeader ?? "")}"
        Log.print("Body Request \(T.self): \n\(String(describing: json))", typePrint: .alert)
        
        return json.data(using: .utf8)
    }
    
    private func getHttpBody<T: BasePojo>(header: BodyHeader, body: [T]) -> Data? {
        
        let jsonHeader = header.toJSONString()
        let jsonBody = body.toJSONString()
        
        let json = "{\"body\":\(jsonBody ?? ""),\"header\":\(jsonHeader ?? "")}"
        Log.print("Body Request \(T.self): \n\(String(describing: json))", typePrint: .alert)
        
        return json.data(using: .utf8)
    }
}
