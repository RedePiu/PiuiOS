//
//  TableViewCell.swift
//  MyQiwi
//
//  Created by Ailton on 23/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class StatementItemCell: UIBaseTableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imgCircle: UIImageView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnSeeOrder: UIButton!
    @IBOutlet weak var viewLineTop: UIView!
    @IBOutlet weak var viewLineBottom: UIView!
    
    // MARK: Variables
    var item: StatementTransactions! {
        
        didSet {
            self.prepareCell()
            
            let isQiwiBalance = item.value > 0
            var valueText = Util.formatCoin(value: item.value)
            
            if isQiwiBalance {
                self.lbValue.textColor = Theme.default.green
            } else {
                self.lbValue.textColor = Theme.default.red
                valueText = "-" + valueText
            }
            
            self.lbValue.text = valueText
            self.lbDesc.text = item.desc
            self.btnSeeOrder.alpha = (item.orderId != 0 || item.transactionId != 0) ? 1 : 0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Resetar style
        
    }
    
    // MARK: Custom fuction
    
    func prepareCell() {
        self.lbValue.setupDefaultTextStyle()
        self.lbDesc.setupDefaultTextStyle()
        //self.btnSeeOrder.titleLabel?.setupDefaultTextStyle()
    }
}
