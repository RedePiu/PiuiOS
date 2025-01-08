//
//  Button+Extension.swift
//  MyQiwi
//
//  Created by Douglas on 04/05/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

extension UIButton {
    
    func isHiddenSuperview(hide: Bool) {
        self.superview!.isHidden = hide
    }
    
    func setTitle(_ title: String, uppercase: Bool = true) {
        self.setTitle(uppercase ? title.uppercased() : title, for: .normal)
    }
    
    func setText(_ title: String) {
        self.setTitle(title, for: .normal)
    }
}
