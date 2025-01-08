//
//  ReceiptItemCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 04/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ReceiptItemCell: UIBaseTableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnSeeOrder: UIButton!
    
    // MARK: Variables
    var item: Receipt! {
        
        didSet {
            self.prepareCell()
            
            //let isQiwiBalance = item.value > 0
            let valueText = Util.formatCoin(value: item.transitionValue)

            self.lbValue.textColor = Theme.default.orange
            self.lbValue.text = valueText
            self.lbDesc.text = item.receiptResume
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Resetar style
        
    }
    
    // MARK: Custom fuction
    
    func prepareCell() {
        self.lbValue.setupDefaultTextStyle()
        //self.lbDesc.setupDefaultTextStyle()
        self.btnSeeOrder.titleLabel?.setupDefaultTextStyle()
    }
}

