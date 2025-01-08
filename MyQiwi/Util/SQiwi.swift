//
//  SQiwi.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 24/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import SecurityFramework

class SQiwi {
    
    //Must be called when app is initializing
    static func iT() -> Int {
        return Int(SecurityInterface.iT())
    }
    
    //Must be called when make a request
    static func cA(a: String, t: Int, s: Int) -> String {
        return SecurityInterface.cA(a, Int32(t), s)
    }
    
    //Must be called to send throw baptism
    static func gB() -> String {
        return SecurityInterface.gB()
    }
    
    //Must be called to verify the baptism
    static func vB(b: String) -> Int {
        return Int(SecurityInterface.vB(b))
    }
    
    //Must be called to check if has to baptism or not
    static func tC() -> Int {
        return Int(SecurityInterface.tC())
    }
    
    //Must be called when get a response
    static func vA(a: String, t: Int, s: Int, f: String) -> Int {
        return Int(SecurityInterface.vA(a, Int32(t), s, f))
    }
    
    //Must pass the S as a param and header as b
    static func sS(a: String, t: Int, s: Int) -> Int {
        return Int(SecurityInterface.sS(a, Int32(t), s))
    }
    
    //Must pass t as a param and header as b
    static func sT(a: String, t: Int, s: Int) -> Int {
        return Int(SecurityInterface.sT(a, Int32(t), s))
    }
    
    //Must be called to validate qiwi pw. a = pw, b = cel, c = header
    static func cS(a: String, b: String, t: Int, s: Int) -> String {
        return SecurityInterface.cS(a, b, Int32(t), s)
    }
    
    //must be called at init
    static func sTA(a: String) -> Int {
        return Int(SecurityInterface.sTA(a))
    }
    
    static func gTP() -> String {
        return SecurityInterface.gTP()
    }
}

