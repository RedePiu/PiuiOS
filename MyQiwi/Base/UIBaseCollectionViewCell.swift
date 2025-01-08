//
//  UIBaseCollectionViewCell.swift
//  MyQiwi
//
//  Created by ailton on 28/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class UIBaseCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupViewCard(radius: 2)
        
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
        
//        let darkView = UIView(frame: bounds)
//        darkView.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
//        self.selectedBackgroundView = darkView
    }
}
