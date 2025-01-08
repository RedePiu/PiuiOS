//
//  UIBaseButton.swift
//  MyQiwi
//
//  Created by ailton on 28/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class BaseButton: UIButton {

    lazy var radiusLayer = CGFloat(3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViewCard(radius: radiusLayer)
//        Util.setAsCardView(view: self, radius: self.radiusLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupViewCard(radius: radiusLayer)
//        Util.setAsCardView(view: self, radius: self.radiusLayer)
    }
}
