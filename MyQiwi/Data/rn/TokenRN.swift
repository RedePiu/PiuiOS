
//
//  TokenRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class TokenRN: BaseRN {

    //UserDefaults.standard
    func validateToken(token: String) {
        //"21EBD4ED7B1B288E5B00D2EA312E7A27DC50006C9DE10EB080F367FE6203C495B9A0AD3F9F3D56751CF8B89AC4BC695D5E0A988D2811D5D72D883F98825D94F5" mock
        let serviceBody = getServiceBody(TokenRequest.self, objectData: TokenRequest(token: token))
        let request = RestApi().generedRequestPost(url: BaseURL.AuthenticatedTokenValidation, object: serviceBody)
        
        callApi(TokenValidationResponse.self, request: request) { (response) in
            self.sendContact(fromClass: TokenRN.self, param: Param.Contact.TOKEN_VALIDATION_RESPONSE, result: response.sucess)
        }
    }
    
    static func setHasToken(hasToken: Bool) {
        UserDefaults.standard.set(hasToken, forKey: PrefsKeys.PREFS_HAS_TOKEN)
        UserDefaults.standard.synchronize()
    }
    
    static func hasToken() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_HAS_TOKEN)
    }
}
