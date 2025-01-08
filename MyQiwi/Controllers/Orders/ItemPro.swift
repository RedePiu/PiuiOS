//
//  ItemPro.swift
//  MyQiwi
//
//  Created by Thyago on 16/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ItemPro: UIBaseTableViewCell {

    @IBOutlet weak var lbItemDesc: UILabel!
    @IBOutlet weak var lbTitleCost: UILabel!
    @IBOutlet weak var lbTitleCredit: UILabel!
    @IBOutlet weak var textCost: UILabel!
    @IBOutlet weak var textCredit: UILabel!
    
    var item : BalancePro! {
        
        didSet {
            self.lbItemDesc.text = item.desc
            self.textCost.text = item.cost
            self.textCredit.text = item.credit
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
