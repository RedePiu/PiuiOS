//
//  ResponseCodes.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class ResponseCodes {
    
    static let GENERIC_APP_ERROR = -1
    static let RESPONSE_OK = 200
    static let SEQ_ERROR = -99
    static let SIGNTURE_ERROR = -98
    static let USER_NOT_LOGGED = -97
    static let USER_QIWI_PASS_WRONG = -96
    static let NO_NETWORK = -95
    static let PARKING_WARNING = 10
    static let USER_ALREADY_EXISTS = -94
    static let INSERT_COUPON_ERROR = -93
    static let USER_BLOCKED = -93 //Nao tem problema ser igual ao do cupom pois sao usados em lugares diferentes
    
    struct Parking {
        static let WARNING = 10
    }
}
