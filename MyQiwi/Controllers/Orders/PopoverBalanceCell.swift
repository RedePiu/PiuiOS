//
//  PopoverBalanceCell.swift
//  MyQiwi
//
//  Created by Thyago on 17/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class PopoverBalanceCell: UIBaseTableViewCell {

    @IBOutlet weak var lbMainDesc: UILabel!
    @IBOutlet weak var lbMainCost: UILabel!
    @IBOutlet weak var lbMainReceive: UILabel!
    
    var item : ProValue! {
        
        didSet {
            
            self.lbMainDesc.text = item.name
            self.lbMainCost.text = Util.formatCoin(value: item.price)
            self.lbMainReceive.text = Util.formatCoin(value: item.commission)
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
    
    func setLayout(){
        
//        Theme.default.textAsDefault(self.lbMainDesc)
//        Theme.default.textAsDefault(self.lbMainCost)
//        Theme.default.textAsDefault(self.lbMainReceive)
    }
}
