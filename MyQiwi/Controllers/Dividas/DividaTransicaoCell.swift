//
//  DividaTransicaoCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 15/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividaTransicaoCell: UIBaseTableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbCommission: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var imgValue: UIImageView!
    @IBOutlet weak var imgCommission: UIImageView!
    
    var item: DividaDetailsResponse! {
        
        didSet {
            
            self.lbName.text = item.productName
            self.lbDate.text = DateFormatterQiwi.formatDate(item.dateCreation, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateBrazil)
            
            self.lbValue.text = Util.formatCoin(value: item.valueTransition)
            self.lbCommission.text = Util.formatCoin(value: item.valueComission)
            
            self.imgValue.image = #imageLiteral(resourceName: "ic_coin").withRenderingMode(.alwaysTemplate)
            self.imgValue.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey4)
            self.imgCommission.image = #imageLiteral(resourceName: "ic_commission").withRenderingMode(.alwaysTemplate)
            self.imgCommission.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey4)
        }
    }
}
