//
//  ConfirmCnpjViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 14/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ConfirmCnpjViewController: LoadBaseView {
    
    
    @IBOutlet weak var lbLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    override func initCoder() {
        self.loadNib(name: "ConfirmCnpj")
    }

}

extension ConfirmCnpjViewController: SetupUI{
    func setupUI() {
        Theme.default.textAsListTitle(self.lbLabel)
        Theme.default.blueButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
    }
    func setupTexts() {
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    }
}
