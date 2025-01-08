//
//  ConfimBuyViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 27/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ConfirmBuyViewController: UIBaseViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var btnSeeBill: UIButton!
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
}

extension ConfirmBuyViewController{
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.greenButton(self.btnSeeBill)
        Theme.default.textAsListTitle(self.mainTitle)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "parking_title_nav".localized)
        self.btnSeeBill.setTitle("parking_see_order".localized, for: .normal)
    }
}
