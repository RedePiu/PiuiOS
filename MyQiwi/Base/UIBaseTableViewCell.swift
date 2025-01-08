//
//  UIBaseTableViewCell.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 27/09/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import UIKit

class UIBaseTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
        
        let darkView = UIView(frame: bounds)
        darkView.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
        self.selectedBackgroundView = darkView
    }
}
