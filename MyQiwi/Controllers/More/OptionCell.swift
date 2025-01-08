//
//  OptionCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 26/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class OptionCell: UIBaseTableViewCell {

    @IBOutlet weak var lbOption: UILabel!
    @IBOutlet weak var imgOption: UIImageView!
    
    var item: MenuItem! {
        didSet {
            
            if item.action == ActionFinder.Account.CHANGE_PASSWORD {
                let texts = ["trocar minha ", "SENHA DE ACESSO"]
                let hexs = [Constants.Colors.Hex.colorQiwiDark, Constants.Colors.Hex.colorButtonGreen]
                self.lbOption.attributedText = Util.formatAttributedText(texts: texts, hex: hexs)
                
            } else if item.action == ActionFinder.Account.QIWI_PASS {
                let texts = ["trocar minha ", "SENHA DA CONTA PIU"]
                let hexs = [Constants.Colors.Hex.colorQiwiDark, Constants.Colors.Hex.colorButtonRed]
                self.lbOption.attributedText = Util.formatAttributedText(texts: texts, hex: hexs)
                
            } else {
                self.lbOption.text = item.desc
            }

            self.imgOption.image = UIImage(named: item.imageMenu ?? "")?.withRenderingMode(.alwaysTemplate)
            
            self.setupCell()
        }
    }
}

extension OptionCell {
    
    func setupCell() {
        self.imgOption.tintColor = Theme.default.blue
        //Theme.More.textAsMenu(self.lbOption)
    }
}
