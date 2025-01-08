//
//  MetrocardBalanceCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 31/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class MetrocardBalanceCell : UIBaseCollectionViewCell {
    
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbSerie: UILabel!
    
    
    override func awakeFromNib() {
        self.layer.masksToBounds = false
        self.contentView.layer.masksToBounds = false
    }
    
    func displayContent(balance: MetrocardBalance) {
        
        self.lbValue.text = Util.formatCoin(value: balance.balance)
        self.lbDate.text = "metrocard_balance_date".localized.replacingOccurrences(of: "{date}", with: DateFormatterQiwi.formatDate(balance.date, currentFormat: DateFormatterQiwi.defaultDateWithoutTPattern, toFormat: DateFormatterQiwi.dateAndHour))
        self.lbSerie.text = String(balance.serieNumber)
    }
}
