//
//  ViewSaveCard.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewSaveCard: LoadBaseView {

    // MARK: Outlets
    
    @IBOutlet weak var txtCVV: MaterialField!
    
    // MARK: Variables
    
    var isSaveCard = false
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewSaveCard")
        self.setupViewSaveCard()
    }
}

// MARK: IBAction

extension ViewSaveCard {
    
    @objc func toggleCheckBox() {
        
//        self.isSaveCard = !self.isSaveCard
//
//        if !self.isSaveCard {
//            self.imgCheckBox.image = Constants.Image.Button.CHECK_BOX_DISABLED
//            return
//        }
//
//        self.imgCheckBox.image = Constants.Image.Button.CHECK_BOX_ENABLE
//        self.imgCheckBox.tintColor = Theme.default.orange
    }
}

// MARK: Setup
extension ViewSaveCard {
    
    func setupViewSaveCard() {
        
        self.txtCVV.placeholder = "checkout_cvv".localized
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleCheckBox))
        tapGesture.numberOfTapsRequired = 1
    }
    
    func setupTextFields() {
        self.txtCVV.formatPattern = Constants.FormatPattern.CreditCard.CVV.rawValue
    }
}
