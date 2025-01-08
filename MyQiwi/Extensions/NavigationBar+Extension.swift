//
//  NavigationBar+Extension.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 04/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

extension UINavigationController {
 
    func transparentNavBar() {
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.barStyle = .default
    }
    
    func defaultNavBar() {
        
        self.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.isTranslucent = true
        self.navigationBar.barStyle = .default
    }
    
    func setupDefault() {
    }
}
