//
//  CommisionCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class CommissionCell: UIBaseTableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var lbName: UILabel?
    @IBOutlet weak var lbTax: UILabel!
    
    // MARK: Variables
    
    var item: Commission! {
        
        didSet {
            self.lbName?.text = item.name
            self.lbTax.text = "\(item.tax)"
            
            self.prepareCell()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Custom fuction
    
    func prepareCell() {
        self.lbName?.setupTitleMedium()
        self.lbTax.setupMessageNormal()
    }
}

