//
//  BaseRN.swift
//  MyQiwi
//
//  Created by ailton on 16/01/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?)
}

class BaseRN {
    public var delegate: BaseDelegate?
    
    internal var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    internal var currentViewController: UIViewController?
    
    // MARK: Variables
    internal var mActiveThreads: [Thread] = []
    
    // MARK: Constants
    static let GENERATE_SEQUENCE = -99
    
    init(delegate: BaseDelegate?) {
        self.delegate = delegate
    }
    
    func createThread() {}
    
    func stopAllThreads() {}
    
    func getDataObj<T:BasePojo>(_ type: T.Type, serviceResponse: ServiceResponse<T>) -> String {
        serviceResponse.body!.data?.toJSONString() ?? "{}"
    }
    
    func generateBodyHeader<T:BasePojo>(_ type: T.Type, data: T?, seq: Int, generateSignutre: Bool) -> BodyHeader {
        let bodyHeader = BodyHeader()
        bodyHeader.terminalId = BaseRN.getTerminalId()
        
        if T.self is BaptismBody.Type {
            bodyHeader.terminalId = "-1"
        }
        
        bodyHeader.seq = (seq != BaseRN.GENERATE_SEQUENCE ? seq : getNextSequencial())
        bodyHeader.f = ""
        
        if generateSignutre {
            let f = RestHelper.verifyObject(T.self, dataObject: data, headerObject: bodyHeader)
            bodyHeader.f = f
        }
        
        return bodyHeader
    }
    
    func generateBodyHeaderList<T:BasePojo>(_ type: T.Type, data: [T]?, seq: Int, generateSignutre: Bool) -> BodyHeader {
        
        let bodyHeader = BodyHeader()
        bodyHeader.terminalId = BaseRN.getTerminalId()
        
        if T.self is BaptismBody.Type {
            bodyHeader.terminalId = "-1"
        }
        
        bodyHeader.seq = (seq != BaseRN.GENERATE_SEQUENCE ? seq : getNextSequencial())
        bodyHeader.f = ""
        
        if generateSignutre {
            let f = RestHelper.verifyObject(T.self, dataObject: data, headerObject: bodyHeader)
            bodyHeader.f = f
        }
        
        return bodyHeader
    }
    
    func generateBodyHeader(body: InitializationBody, seq: Int, generateSignutre: Bool) -> BodyHeader {
        let bodyHeader = BodyHeader()
        bodyHeader.terminalId = BaseRN.getTerminalId()
        bodyHeader.seq = (seq != BaseRN.GENERATE_SEQUENCE ? seq : getNextSequencial())
        bodyHeader.f = ""
        
        if generateSignutre {
            let f = RestHelper.verifyObject(dataObject: body, headerObject: bodyHeader)
            bodyHeader.f = f
        }
        
        return bodyHeader
    }
    
    // Get a service body to be used on service requests
    func getServiceBody<T:BasePojo>(_ type: T.Type, objectData: T?, seq: Int = BaseRN.GENERATE_SEQUENCE, generateSignture: Bool = true) -> ServiceBody<T> {
        let bodyHeader = generateBodyHeader(T.self, data: objectData, seq: seq, generateSignutre: generateSignture)
        let serviceBody = ServiceBody<T>(header: bodyHeader, data: objectData)
        return serviceBody
    }
    
    // Get a service body to be used on service requests
    func getServiceBodyList<T:BasePojo>(_ type: T.Type, objectData: [T]?, seq: Int = BaseRN.GENERATE_SEQUENCE, generateSignture: Bool = true) -> ServiceBodyList<T> {
        let bodyHeader = generateBodyHeaderList(T.self, data: objectData, seq: seq, generateSignutre: generateSignture)
        let serviceBody = ServiceBodyList<T>(header: bodyHeader, data: objectData)
        return serviceBody
    }
    
    // Get a service body to be used on service requests
    func getServiceBody(objectData: InitializationBody, seq: Int = BaseRN.GENERATE_SEQUENCE, generateSignture: Bool = true) -> ServiceBody<InitializationBody> {
        let bodyHeader = generateBodyHeader(body: objectData, seq: seq, generateSignutre: generateSignture)
        let serviceBody = ServiceBody<InitializationBody>(header: bodyHeader, data: objectData)
        return serviceBody
    }
    
    //At this case JSON must be ordened with a specific order.
    //updateJsonWithHeader must be called with generateJsonBody
    //A data object will be returned to send to the server
    func updateJsonWithHeader(jsonBody: String, seq: Int = BaseRN.GENERATE_SEQUENCE, generateSignture: Bool = true) -> Data {
        let bodyHeader = BodyHeader()
        bodyHeader.terminalId = BaseRN.getTerminalId()
        bodyHeader.seq = (seq != BaseRN.GENERATE_SEQUENCE ? seq : getNextSequencial())
        bodyHeader.f = ""
        
        if generateSignture {
            let f = RestHelper.verifyJsonObject(dataObject: jsonBody, headerObject: bodyHeader)
            bodyHeader.f = f
        }
        
        print("@ >>> BODY_HEADER: ", bodyHeader)
        print("@ >>> SEQUENCY: ", seq)
        
        let bodyString = "{\"body\":" + jsonBody + ",\"header\":{\"f\":\"\(bodyHeader.f)\",\"sequencial\":\(bodyHeader.seq),\"codterminal\":\"\(bodyHeader.terminalId)\"}}"
        
        let data =  bodyString.data(using: .utf8, allowLossyConversion: false)!
        
        if let jsonString = String(data: data, encoding: .utf8) {
            Log.print("Server request: \n\(jsonString)", typePrint: .alert)
        }
        
        return data
    }
    
    //At this case JSON must be ordened with a specific order.
    //updateJsonWithHeader must be called with generateJsonBody
    //A data object will be returned to send to the server
    func updateJsonWithHeader(jsonBody: Data, seq: Int = BaseRN.GENERATE_SEQUENCE, generateSignture: Bool = true) -> Data {
        let string = String(data: jsonBody, encoding: .utf8)
        return updateJsonWithHeader(jsonBody: string != nil ? string! : "", seq: seq, generateSignture: generateSignture)
    }
    
    //Defines the new sequential number
    func setSequential(seq: Int) {
        self.userDefaults.set(seq, forKey: PrefsKeys.PREFS_SEQUENTIAL)
        self.userDefaults.synchronize()
    }
    
    //Defines the new terminal id
    func setTerminalId(terminalId: String) {}
    
    //Get the saved terminal id number
    static func getTerminalId() -> String {
        return "\(SQiwi.tC())"
    }
    
    // Defines the new s
    func setS(s: String) {
        self.userDefaults.set(s, forKey: PrefsKeys.PREFS_S)
        self.userDefaults.synchronize()
    }
    
    /**
     * Get the saved s value
     * @param context App context
     * @return The saved s or empty if doesn't exists.
     */
    func getS() -> String {
        return self.userDefaults.string(forKey: PrefsKeys.PREFS_S) ?? ""
    }
    
    /**
     * Get the next saved sequential number
     * Returns the saved sequential number or -1 if doesn`t exists.
     */
    func getNextSequencial() -> Int {
        
        var returnedSequencial = self.userDefaults.integer(forKey: PrefsKeys.PREFS_SEQUENTIAL)
        
        // Value is Zero, return default Value "-2"
        returnedSequencial = returnedSequencial == 0 ? -2 : (returnedSequencial + 1)
        
        //Saves the new sequencial value
        setSequential(seq: returnedSequencial)
        
        return returnedSequencial
    }
    
    /**
     * Get the saved sequential number
     * @param context App context
     * @return The saved sequential number or -1 if doesn't exists.
     */
    func getCurrentSequencial() -> Int {
        var currentSequencial = self.userDefaults.integer(forKey: PrefsKeys.PREFS_SEQUENTIAL)
        // Value is Zero, return default Value "-2"
        currentSequencial = currentSequencial == 0 ? -2 : currentSequencial
        return currentSequencial
    }
    
    func callApiDataInt(request: URLRequest, completion: @escaping (_ service: ServiceResponseDataInt) -> Void) {
        if !Util.checkReachable() {
            let response = ServiceResponseDataInt(header: BodyHeaderResponse(), body: nil)
            completion(response)
            self.sendContact(fromClass: BaseRN.self, param: Param.Contact.NET_REQUEST_NO_NETWORK, result: false, object: response)
            return
        }
        
        RestApi().execute(request) { (data, error) in
            var serviceResponse: ServiceResponseDataInt!
            let defaultResponseEmpty = ServiceResponseDataInt(header: BodyHeaderResponse(), body: nil)
            
            if let err = error {
                Log.print(err, typePrint: .warning)
                Log.print(err.localizedDescription, typePrint: .warning)
                completion(defaultResponseEmpty)
                return
            }
            
            if let data = data {
                let json = String(data: data, encoding: .utf8)!
                Log.print("Response Server \(String(describing: request.url?.absoluteString)) - \("Json"): \n\(json)")
                let serviceGenericResponse = Mapper<ServiceResponseDataInt>().map(JSONString: String(data: data, encoding: .utf8)!)
                serviceResponse = serviceGenericResponse
            }
            
            if serviceResponse == nil {
                serviceResponse = ServiceResponseDataInt(header: BodyHeaderResponse(), body: nil)
            }
            
            if let serviceResponse = serviceResponse {
                if serviceResponse.body == nil {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_ERROR, result: true, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                if let serviceBody = serviceResponse.body {
                    if serviceBody.cod != ResponseCodes.RESPONSE_OK {
                        if serviceBody.cod == ResponseCodes.SEQ_ERROR ||
                            serviceBody.cod == ResponseCodes.SIGNTURE_ERROR {
                            self.startReinitializeActivity()
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.USER_NOT_LOGGED {
                            self.startWarningActivity(isLogout: true)
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.GENERIC_APP_ERROR ||
                            serviceBody.cod >= 400 {
                            self.showDefaultOKMessage(message: serviceBody.showMessages())
                            self.sendContact(
                                fromClass: UserRN.self,
                                param: Param.Contact.NET_REQUEST_ERROR,
                                result: true,
                                object: serviceBody.showMessages() as AnyObject
                            )
                        }
                        
                        completion(serviceResponse)
                        return
                    }
                }
                
                if !RestHelper.verifyResponse(response: serviceResponse) {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                serviceResponse.sucess = true
            }
            
            completion(serviceResponse)
        }
    }
    
    func callApiDataString(request: URLRequest, completion: @escaping (_ service: ServiceResponseDataString) -> Void) {
        if !Util.checkReachable() {
            let response = ServiceResponseDataString(header: BodyHeaderResponse(), body: nil)
            completion(response)
            self.sendContact(fromClass: BaseRN.self, param: Param.Contact.NET_REQUEST_NO_NETWORK, result: false, object: response)
            return
        }
        
        RestApi().execute(request) { (data, error) in
            var serviceResponse: ServiceResponseDataString!
            let defaultResponseEmpty = ServiceResponseDataString(header: BodyHeaderResponse(), body: nil)
            
            if let err = error {
                Log.print(err, typePrint: .warning)
                Log.print(err.localizedDescription, typePrint: .warning)
                completion(defaultResponseEmpty)
                return
            }
            
            if let data = data {
                let json = String(data: data, encoding: .utf8)!
                Log.print("Response Server \(String(describing: request.url?.absoluteString)) - \("Json"): \n\(json)")
                let serviceGenericResponse = Mapper<ServiceResponseDataString>().map(JSONString: String(data: data, encoding: .utf8)!)
                serviceResponse = serviceGenericResponse
            }
            
            if serviceResponse == nil {
                serviceResponse = ServiceResponseDataString(header: BodyHeaderResponse(), body: nil)
            }
            
            if let serviceResponse = serviceResponse {
                if serviceResponse.body == nil {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_ERROR, result: true, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                if let serviceBody = serviceResponse.body {
                    if serviceBody.cod != ResponseCodes.RESPONSE_OK {
                        if serviceBody.cod == ResponseCodes.SEQ_ERROR ||
                            serviceBody.cod == ResponseCodes.SIGNTURE_ERROR {
                            self.startReinitializeActivity()
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.USER_NOT_LOGGED {
                            self.startWarningActivity(isLogout: true)
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.GENERIC_APP_ERROR ||
                            serviceBody.cod >= 400 {
                            self.showDefaultOKMessage(message: serviceBody.showMessages())
                            self.sendContact(
                                fromClass: UserRN.self,
                                param: Param.Contact.NET_REQUEST_ERROR,
                                result: true,
                                object: serviceBody.showMessages() as AnyObject
                            )
                        }
                        
                        completion(serviceResponse)
                        return
                    }
                }
                
                if !RestHelper.verifyResponse(response: serviceResponse) {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                serviceResponse.sucess = true
            }
            
            completion(serviceResponse)
        }
    }
    
    func callApiDataBool(request: URLRequest, completion: @escaping (_ service: ServiceResponseDataBool) -> Void) {
        if !Util.checkReachable() {
            let response = ServiceResponseDataBool(header: BodyHeaderResponse(), body: nil)
            completion(response)
            self.sendContact(fromClass: BaseRN.self, param: Param.Contact.NET_REQUEST_NO_NETWORK, result: false, object: response)
            return
        }
        
        RestApi().execute(request) { (data, error) in
            var serviceResponse: ServiceResponseDataBool!
            let defaultResponseEmpty = ServiceResponseDataBool(header: BodyHeaderResponse(), body: nil)
            
            if let err = error {
                Log.print(err, typePrint: .warning)
                Log.print(err.localizedDescription, typePrint: .warning)
                completion(defaultResponseEmpty)
                return
            }
            
            if let data = data {
                let json = String(data: data, encoding: .utf8)!
                Log.print("Response Server \(String(describing: request.url?.absoluteString)) - \("Json"): \n\(json)")
                let serviceGenericResponse = Mapper<ServiceResponseDataBool>().map(JSONString: String(data: data, encoding: .utf8)!)
                serviceResponse = serviceGenericResponse
            }
            
            if serviceResponse == nil {
                serviceResponse = ServiceResponseDataBool(header: BodyHeaderResponse(), body: nil)
            }
            
            if let serviceResponse = serviceResponse {
                if serviceResponse.body == nil {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_ERROR, result: true, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                if let serviceBody = serviceResponse.body {
                    if serviceBody.cod != ResponseCodes.RESPONSE_OK {
                        if serviceBody.cod == ResponseCodes.SEQ_ERROR ||
                            serviceBody.cod == ResponseCodes.SIGNTURE_ERROR {
                            self.startReinitializeActivity()
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.USER_NOT_LOGGED {
                            self.startWarningActivity(isLogout: true)
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.GENERIC_APP_ERROR ||
                            serviceBody.cod >= 400 {
                            self.showDefaultOKMessage(message: serviceBody.showMessages())
                            self.sendContact(
                                fromClass: UserRN.self,
                                param: Param.Contact.NET_REQUEST_ERROR,
                                result: true,
                                object: serviceBody.showMessages() as AnyObject
                            )
                        }
                        
                        completion(serviceResponse)
                        return
                    }
                }
                
                if !RestHelper.verifyResponse(response: serviceResponse) {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                serviceResponse.sucess = true
            }
            
            completion(serviceResponse)
        }
    }
    
    func callApi(request: URLRequest, completion: @escaping (_ service: ServiceResponseWithJson) -> Void) {
        if !Util.checkReachable() {
            let response = ServiceResponseWithJson(header: BodyHeaderResponse(), body: nil)
            completion(response)
            self.sendContact(fromClass: BaseRN.self, param: Param.Contact.NET_REQUEST_NO_NETWORK, result: false, object: response)
            return
        }
        
        RestApi().execute(request) { (data, error) in
            var serviceResponse: ServiceResponseWithJson!
            let defaultResponseEmpty = ServiceResponseWithJson(header: BodyHeaderResponse(), body: nil)
        
            if let err = error {
                Log.print(err, typePrint: .warning)
                Log.print(err.localizedDescription, typePrint: .warning)
                completion(defaultResponseEmpty)
                return
            }
            
            if let data = data {
                let json = String(data: data, encoding: .utf8)!
                Log.print("Response Server \(String(describing: request.url?.absoluteString)) - \("Json"): \n\(json)")
                let serviceGenericResponse = Mapper<ServiceResponseWithJson>().map(JSONString: String(data: data, encoding: .utf8)!)
                serviceResponse = serviceGenericResponse
            }
            
            if serviceResponse == nil {
                serviceResponse = ServiceResponseWithJson(header: BodyHeaderResponse(), body: nil)
            }
            
            if let serviceResponse = serviceResponse {
                if serviceResponse.body == nil {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_ERROR, result: true, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                if let serviceBody = serviceResponse.body {
                    if serviceBody.cod != ResponseCodes.RESPONSE_OK {
                        if serviceBody.cod == ResponseCodes.SEQ_ERROR ||
                            serviceBody.cod == ResponseCodes.SIGNTURE_ERROR {
                            self.startReinitializeActivity()
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.USER_NOT_LOGGED {
                            self.startWarningActivity(isLogout: true)
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.GENERIC_APP_ERROR ||
                            serviceBody.cod >= 400 {
                            self.showDefaultOKMessage(message: serviceBody.showMessages())
                            self.sendContact(
                                fromClass: UserRN.self,
                                param: Param.Contact.NET_REQUEST_ERROR,
                                result: true,
                                object: serviceBody.showMessages() as AnyObject
                            )
                        }
                        
                        completion(serviceResponse)
                        return
                    }
                }
                
                if !RestHelper.verifyResponse(response: serviceResponse) {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                serviceResponse.sucess = true
            }
            
            completion(serviceResponse)
        }
    }
    
    func callApi<R:BasePojo>(_ response: R.Type, request: URLRequest, completion: @escaping (_ service: ServiceResponse<R>) -> Void) {
        if !Util.checkReachable() {
            let response = ServiceResponse<R>(header: BodyHeaderResponse(), body: nil)
            completion(response)
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_NO_NETWORK, result: false, object: response)
            return
        }
        
        RestApi().execute(request) { (data, error) in
            var serviceResponse: ServiceResponse<R>!
            let defaultResponseEmpty = ServiceResponse<R>(header: BodyHeaderResponse(), body: nil)
            
            if let err = error {
                Log.print(err, typePrint: .warning)
                Log.print(err.localizedDescription, typePrint: .warning)
                completion(defaultResponseEmpty)
                return
            }
            
            if let data = data {
                Log.print("Response Server \(String(describing: request.url?.absoluteString)) - \(R.self): \n\(String(data: data, encoding: .utf8)!)")
                let serviceGenericResponse = Mapper<ServiceResponse<R>>().map(JSONString: String(data: data, encoding: .utf8)!)
                serviceResponse = serviceGenericResponse
            }
            
            if serviceResponse == nil {
                serviceResponse = ServiceResponse<R>(header: BodyHeaderResponse(), body: nil)
            }
            
            if let serviceResponse = serviceResponse {
                if serviceResponse.body == nil {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_ERROR, result: true, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                if let serviceBody = serviceResponse.body {
                    if serviceBody.cod != ResponseCodes.RESPONSE_OK {
                        if serviceBody.cod == ResponseCodes.SEQ_ERROR ||
                            serviceBody.cod == ResponseCodes.SIGNTURE_ERROR {
                            self.startReinitializeActivity()
                            completion(serviceResponse)
                            return
                        }
                    
                        if serviceBody.cod == ResponseCodes.USER_NOT_LOGGED {
                            
                            self.startWarningActivity(isLogout: true)
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.GENERIC_APP_ERROR ||
                            serviceBody.cod >= 400 {
                            self.showDefaultOKMessage(message: serviceBody.showMessages())
                            self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_ERROR, result: true, object: serviceBody.showMessages() as AnyObject)
                        }
                        
                        completion(serviceResponse)
                        return
                    }
                }
                
                if !RestHelper.verifyResponse(R.self, response: serviceResponse) {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                serviceResponse.sucess = true
            }
            
            completion(serviceResponse)
        }
    }
    
    func callApiForList<R:BasePojo>(_ response: R.Type, request: URLRequest, completion: @escaping (_ service: ServiceResponseList<R>) -> Void) {
        if !Util.checkReachable() {
            let response = ServiceResponseList<R>(header: BodyHeaderResponse(), body: nil)
            completion(response)
            self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_NO_NETWORK, result: false, object: response)
            return
        }
        
        RestApi().execute(request) { (data, error) in
            var serviceResponse: ServiceResponseList<R>!
            let defaultResponseEmpty = ServiceResponseList<R>(header: BodyHeaderResponse(), body: nil)
            
            if let err = error {
                Log.print(err, typePrint: .warning)
                Log.print(err.localizedDescription, typePrint: .warning)
                completion(defaultResponseEmpty)
                return
            }
            
            if let data = data {
                Log.print("Response Server \(String(describing: request.url?.absoluteString)) - \(R.self): \n\(String(data: data, encoding: .utf8)!)")
                let serviceGenericResponse = Mapper<ServiceResponseList<R>>().map(JSONString: String(data: data, encoding: .utf8)!)
                serviceResponse = serviceGenericResponse
            }
            
            if serviceResponse == nil {
                serviceResponse = ServiceResponseList<R>(header: BodyHeaderResponse(), body: nil)
            }
            
            if let serviceResponse = serviceResponse {
                if serviceResponse.body == nil {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_ERROR, result: true, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                if let serviceBody = serviceResponse.body {
                    if serviceBody.cod != ResponseCodes.RESPONSE_OK {
                        if serviceBody.cod == ResponseCodes.SEQ_ERROR ||
                            serviceBody.cod == ResponseCodes.SIGNTURE_ERROR {
                            self.startReinitializeActivity()
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.USER_NOT_LOGGED {
                            self.startWarningActivity(isLogout: true)
                            completion(serviceResponse)
                            return
                        }
                        
                        if serviceBody.cod == ResponseCodes.GENERIC_APP_ERROR ||
                            serviceBody.cod >= 400 {
                            self.showDefaultOKMessage(message: serviceBody.showMessages())
                            self.sendContact(
                                fromClass: UserRN.self,
                                param: Param.Contact.NET_REQUEST_ERROR,
                                result: true,
                                object: serviceBody.showMessages() as AnyObject
                            )
                        }
                        
                        completion(serviceResponse)
                        return
                    }
                }
                
                if !RestHelper.verifyResponse(R.self, response: serviceResponse) {
                    self.sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                    completion(serviceResponse)
                    return
                }
                
                serviceResponse.sucess = true
            }
            
            completion(serviceResponse)
        }
    }
    
    func callApi<R:BasePojo>(_ response: R.Type, request: URLRequest) -> ServiceResponse<R> {
        var serviceResponse: ServiceResponse<R>!
        let defaultResponseEmpty = ServiceResponse<R>(header: BodyHeaderResponse(), body: nil)
        let response = RestApi().execute(request)
        
        if let err = response.1 {
            Log.print(err, typePrint: .warning)
            Log.print(err.localizedDescription, typePrint: .warning)
            return defaultResponseEmpty
        }
        
        if let data = response.0 {
            Log.print("dataResponse \(R.self): \n\(String(data: data, encoding: .utf8)!)")
            let serviceGenericResponse = Mapper<ServiceResponse<R>>().map(JSONString: String(data: data, encoding: .utf8)!)
            serviceResponse = serviceGenericResponse
        }
        
        if serviceResponse == nil {
            serviceResponse = ServiceResponse<R>(header: BodyHeaderResponse(), body: nil)
        }
        
        if let serviceResponse = serviceResponse {
            if serviceResponse.body == nil {
                sendContact(fromClass: UserRN.self, param: Param.Contact.NET_REQUEST_ERROR, result: true, object: nil)
                return defaultResponseEmpty
            }
            
            if let serviceBody = serviceResponse.body {
                if serviceBody.cod != ResponseCodes.RESPONSE_OK {
                    if serviceBody.cod == ResponseCodes.SEQ_ERROR ||
                        serviceBody.cod == ResponseCodes.SIGNTURE_ERROR {
                        startReinitializeActivity()
                        return defaultResponseEmpty
                    }
                    
                    if serviceBody.cod == ResponseCodes.USER_NOT_LOGGED {
                        self.startWarningActivity(isLogout: true)
                        return defaultResponseEmpty
                    }
                    
                    if serviceBody.cod == ResponseCodes.GENERIC_APP_ERROR ||
                        serviceBody.cod >= 400 {
                        self.showDefaultOKMessage(message: serviceBody.showMessages())
                        sendContact(
                            fromClass: UserRN.self,
                            param: Param.Contact.NET_REQUEST_ERROR,
                            result: true,
                            object: serviceBody.showMessages() as AnyObject
                        )
                    }
                }
            }
            
            if !RestHelper.verifyResponse(R.self, response: serviceResponse) {
                sendContact(fromClass: UserRN.self, param: Param.Contact.FINISH_ACTIVITY, result: false, object: nil)
                return defaultResponseEmpty
            }
            
            serviceResponse.sucess = true
        }
        
        return serviceResponse
    }
    
    /**
     * Send a message to its creator to inform some message. The message will be received on OnReceiveData at Activities and Fragments or will receive
     * at onComponentContact in classes that implements IComponentContact.
     * @param param The id - use Param.Contact.IDS.
     * @param result If your operations depends of a result, place it here.
     * @param objects If you have extra objects to send, place it here.
     */
    
    func sendContact(fromClass: AnyClass, param: Int, result: Bool = false, object: AnyObject? = nil) {
        self.delegate?.onReceiveData(fromClass: fromClass, param: param, result: result, object: object)
    }
    
    func startWarningActivity(isLogout: Bool) {
        DispatchQueue.main.async {
            Util.showController(WarningViewController.self, sender: self.getTopView(), completion: { controller in
                if isLogout {
                    controller.getLogoutIntent()
                }
            })
        }
    }
    
    func startReinitializeActivity() {
        if let viewController = self.currentViewController {
            Util.showController(WarningViewController.self, sender: viewController)
        }
    }
    
    func showDefaultOKMessage(message: String) {
        DispatchQueue.main.async {
            Util.showAlertDefaultOK(self.getTopView(), message: message)
        }
    }
    
    func getTopView() -> UIViewController {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return UIViewController()
    }
}
