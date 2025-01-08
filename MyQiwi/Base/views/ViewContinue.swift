//
//  ViewContinue.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewContinue: LoadBaseView {

    // MARK: Outlets
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var svBack: UIStackView!
    @IBOutlet weak var svContinue: UIStackView!
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewContinue")
        self.setupViewContinue()
    }
}

// MARK: Setup
extension ViewContinue {
    
    fileprivate func setupViewContinue() {
        
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        self.btnBack.setTitle("back".localized, for: .normal)
    }
    
    func showOnlyBackButton() {
        self.btnBack.isHidden = false
        self.btnContinue.isHidden = true
    }
    
    func showBackAndContinueButtons() {
        self.btnBack.isHidden = false
        self.btnContinue.isHidden = false
    }
}
