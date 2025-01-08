//
//  UrbsCreditTypeCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/07/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class UrbsCreditTypeCell: UIBaseCollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var widthLayout: NSLayoutConstraint?
    @IBOutlet weak var lbTimeData: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    // MARK: Variables
    
    
    
//    var widthCollection: CGFloat = 370 {
//        didSet {
//            self.setCellWidth((widthCollection - (CGFloat(2) * 10)) / 2)
//        }
//    }
    
    // MARK: Methods
    
//    func setCellWidth(_ width: CGFloat) {
//        widthLayout?.constant = width
//    }
    
    func style(_ styleClosure: (UrbsCreditTypeCell) -> Void) -> UrbsCreditTypeCell {
        self.layer.shadowOpacity = 0
        
        return self
    }
    
    func updateBalance(balance: Double) {
        
        if balance > 0 {
            
            self.lbPrice.text = Util.formatCoin(value: balance)
            self.lbPrice.tintColor = Theme.default.green
        }
        else if balance <= 0 {
            
            self.lbPrice.textColor = Theme.default.red
            self.lbPrice.text = Util.formatCoin(value: balance)
        }
    }
    
    //func displayContent(balance: UrbsBalance)
    func displayContent(balance: UrbsBalance) {
        //        let url = URL(string: Params.Net.URL + menu.imageMenu)
        //        menuIcon.kf.setImage(with: url)
        
        
        var image = ""
        var name = ""
        var balanceDate = ""
        
        let formattedDate = DateFormatterQiwi.formatDate(balance.balanceDate, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateAndHour)
        let date = "transport_urbs_balance_date".localized.replacingOccurrences(of: "{date}", with: formattedDate)
        
        if Int(balance.cardTypeCode) == ActionFinder.Transport.UrbsCardType.COMUM {
            image = "ic_transport_comum"
            name = "comum"
            balanceDate = date
        }
        else if Int(balance.cardTypeCode) == ActionFinder.Transport.UrbsCardType.ESTUDANTE {
            image = "ic_studant"
            name = "estudante"
            balanceDate = date
        }
        else if Int(balance.cardTypeCode) == ActionFinder.Transport.UrbsCardType.VT {
            image = "ic_bus"
            name = "vt"
            balanceDate = date
        }
        else if Int(balance.cardTypeCode) == ActionFinder.Transport.UrbsCardType.GRATUIDADE {
            image = "ic_check_box"
            name = "gratuidade"
            balanceDate = date
        }
        
        //let color = selected ? Theme.default.primary : UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        
        self.lbName.text = name
        self.lbName.textColor = Theme.default.blue
        self.imgIcon.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        //self.imgIcon.tintColor = color
        self.lbTimeData.text = balanceDate
        
        self.lbTimeData.textColor = UIColor.lightGray
        self.lbPrice.text = Util.formatCoin(value: balance.balance)
        self.lbPrice.textColor = balance.balance > 0 ? Theme.default.green : Theme.default.red
        
    }
}

