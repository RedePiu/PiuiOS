//
//  ViewCreditCardTokenCell.swift
//  MyQiwi
//
//  Created by Ailton on 25/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewCreditCardTokenCell : UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    // MARK: Variables
    
    var showButton = true
    
    var item: CreditCardToken! {
        
        didSet {
    
            
            self.imgLogo.image = UIImage(named: String("ic_visa_blue"))
            self.lbName?.text = item.getListLabel()
            //self.lbName?.text = item.getStringDigits()
            
            if item.isMaster() {
                self.imgLogo.image = UIImage(named: String("ic_billing_mastercard_logo"))
            }

            self.prepareCell()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Resetar style
        Theme.default.greenButton(self.btnSelect)
    }
    
    // MARK: Custom fuction
    
    func prepareCell() {
        
        Theme.default.greenButton(self.btnSelect)
        self.btnSelect.isHidden = !self.showButton
        self.lbName?.setupMessageNormal()
    }
}

