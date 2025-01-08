//
//  UrbsCardCell.swift
//  MyQiwi
//
//  Created by Thyago on 26/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class UrbsCardCell: UIBaseTableViewCell {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var btnCharge: UIButton!
    @IBOutlet weak var btnSaldo: UIButton!
    @IBOutlet weak var btnExtrato: UIButton!
    
    var item: TransportCard! {
    
        didSet {
            if item.type == ActionFinder.Transport.CardType.URBS {
                self.imgLogo.image = UIImage(named: "100058")
            }
            self.lbName?.text = item.name
            self.lbNumber.text = "\(item.number)"
            
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
        Theme.default.blueButton(self.btnSaldo)
        Theme.default.blueButton(self.btnExtrato)
        
        if item.name.isEmpty {
            self.lbNumber.setupTitleMedium()
            return
        }
        
        self.lbNumber.setupMessageNormal()
        self.lbName?.setupTitleMedium()
    }
}
