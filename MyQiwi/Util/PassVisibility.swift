//
//  PassVisibility.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 12/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class PassVisibility {
    
    static func isHidden() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_IS_HIDDEN)
    }
    
    static func needChangeToAll() -> Bool {
        return UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_CHANGE_ALL)
    }
    
    static func showPopupIfCan(sender: UIViewController) {
        
        if !UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_CAN_SHOW_POPUP) {
            return
        }
        
        Util.showController(PopupPasswordVisibility.self, sender: sender)
    }
    
    static func setIsHidden(isHidden: Bool) {
        
        if !UserDefaults.standard.bool(forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_CHANGE_ALL) {
            return
        }
        
        UserDefaults.standard.set(isHidden, forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_IS_HIDDEN)
        UserDefaults.standard.synchronize()
    }
    
    static func setNeedChangeAll(needChange: Bool) {
        UserDefaults.standard.set(needChange, forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_CHANGE_ALL)
        UserDefaults.standard.synchronize()
    }
    
    static func setCanShowPopup(canShow: Bool) {
        UserDefaults.standard.set(canShow, forKey: PrefsKeys.PREFS_PASSWORD_VISIBILITY_CAN_SHOW_POPUP)
        UserDefaults.standard.synchronize()
    }
}
