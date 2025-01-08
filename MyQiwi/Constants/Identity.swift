//
//  Identity.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class Identity {
    
    static func save(email: String) {
        
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: Constants.KeysIdentity.PREFS_USER_EMAIL)
        defaults.synchronize()
    }
    
    static func getEmail() -> String {
        
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: Constants.KeysIdentity.PREFS_USER_EMAIL) ?? ""
        return email
    }
    
    static func isLogged() -> Bool {
        
        if getEmail().isEmpty {
            return false
        }
        
        return true
    }
    
    static func deleteLogin() {
        UserDefaults.standard.removeObject(forKey: Constants.KeysIdentity.PREFS_USER_EMAIL)
    }
}
