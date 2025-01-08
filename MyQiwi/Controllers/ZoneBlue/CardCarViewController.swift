//
//  CardCarViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 21/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class CardCarViewController: LoadBaseView {
    @IBOutlet weak var btnContinuar: UIButton!
    @IBOutlet weak var titlePlaca: UILabel!
    @IBOutlet weak var carName: UILabel!
    @IBOutlet weak var carIcon: UIImageView!
    
    override func initCoder() {
        self.loadNib(name: "CardCar")
        
        //self.lblNameReceipt.text = UserDefaults.standard.string(forKey: PrefsKeys.PREFS_USER_NAME)
        //self.lblNumberReceipt.text = UserDefaults.standard.string(forKey: PrefsKeys.PREFS_USER_CEL)?.formatText(format: "(##) #####-####")
    }
}

extension CardCarViewController{
    
    func setupUI() {
        Theme.default.greenButton(self.btnContinuar)
        Theme.default.textAsListTitle(self.titlePlaca)
        Theme.default.textAsDefault(self.carName)
        self.carIcon.setupBlue()
    }
    
    func setupTexts() {
        self.btnContinuar.setTitle("parking_button_active".localized, for: .normal)
    }
}
