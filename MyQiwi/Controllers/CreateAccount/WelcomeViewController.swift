//
//  WelcomeViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class WelcomeViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var lblMessageWelcome: UILabel!
    
    @IBOutlet weak var lblText_1: UILabel!
    @IBOutlet weak var lblText_2: UILabel!
    @IBOutlet weak var lblText_3: UILabel!
    @IBOutlet weak var lblText_4: UILabel!
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions
extension WelcomeViewController {
    
    @IBAction func openContinue(sender: UIButton) {
    
        self.backToMainScreen(sender)
        
        // Salvar email do user cadastrado
        Identity.save(email: CreateAccountForm.shared.email)
    }
}

// MARK: SetupUI
extension WelcomeViewController: SetupUI {
    
    func setupUI() {
        
        self.view.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorButtonBlueLight)
        Theme.default.greenButton(self.btnContinue)
        Theme.default.textAsListTitle(self.lblWelcome)
        
        self.lblMessageWelcome.setupTitleMedium()
        self.lblText_1.setupTitleMedium()
        self.lblText_2.setupTitleMedium()
        self.lblText_3.setupTitleMedium()
        self.lblText_4.setupTitleMedium()
    }
    
    func setupTexts() {
        
        self.lblWelcome.text = "welcome_title".localized
        self.lblMessageWelcome.text = "welcome_desc".localized
        
        self.lblText_1.text = "welcome_text_1".localized
        self.lblText_2.text = "welcome_text_2".localized
        self.lblText_3.text = "welcome_text_3".localized
        self.lblText_4.text = "welcome_text_4".localized
        
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        
        Util.setTextBarIn(self, title: "")
    }
}
