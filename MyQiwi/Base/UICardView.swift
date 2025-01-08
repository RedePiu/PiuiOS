//
//  UICardView.swift
//  MyQiwi
//
//  Created by ailton on 28/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class UICardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViewCard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupViewCard()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
//        Util.setAsCardView(view: self, radius: 2)
    }
}
