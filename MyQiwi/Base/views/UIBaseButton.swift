//
//  UIBaseButton.swift
//  MyQiwi
//
//  Created by ailton on 28/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.setTitleColor(UIColor.white, for: UIControlState.normal)
        //self.frame.size = CGSize(width: CGFloat(100), height: CGFloat(40))
    }
}
