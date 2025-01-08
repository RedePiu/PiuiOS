//
//  ViewUserBankCell.swift
//  MyQiwi
//
//  Created by Ailton on 11/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class ViewUserBankCell : UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnCharge: UIButton!
    @IBOutlet weak var lbName: UILabel?
    
    // MARK: Variables
    
    var item: BankRequest! {
        
        didSet {
            var bankText = ""
                
            if !item.nickname.isEmpty {
                bankText = item.nickname + ": "
            }
            
            bankText += "agência " + item.ownerAgency + " conta " + item.ownerAccount
            
            if !item.ownerAccountDigit.isEmpty {
               bankText = bankText + "-" + item.ownerAccountDigit
            }
            
            self.imgLogo.image = UIImage(named: String(item.bankId))
            self.lbName?.text = bankText

            self.prepareCell()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Resetar style
        Theme.default.greenButton(self.btnCharge)
    }
    
    // MARK: Custom fuction
    
    func prepareCell() {
        
        Theme.default.greenButton(self.btnCharge)        
        self.lbName?.setupMessageNormal()
    }
}
