//
//  UltragazUserViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 01/06/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class UltragazUserViewController: UIBaseViewController {
    
    // MARK : VIEWS
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtName: MaterialField!
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var txtEmail: MaterialField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    // MARK : VARIABLES
    
    // MARK : INIT
    override func setupViewDidLoad() {
        super.setupViewDidLoad()
        
        self.setupUI()
        self.setupTexts()
    }
}

extension UltragazUserViewController {
    
    func validateInput() -> Bool {
        let name = self.txtName.text ?? ""
        let cpf = self.txtCPF.text ?? ""
        let email = self.txtEmail.text ?? ""
        
        if name.isEmpty {
            return false
        }
        
        if !cpf.isValidCPF {
            return false
        }
        
        if !email.isEmail() {
            return false
        }
        
        QiwiOrder.checkoutBody.requestUltragaz?.name = name
        QiwiOrder.checkoutBody.requestUltragaz?.document = cpf.removeAllOtherCaracters()
        QiwiOrder.checkoutBody.requestUltragaz?.email = email
        
        return true
    }
}

extension UltragazUserViewController {
    
    @IBAction func onClickBack(_ sender: Any) {
        self.popPage()
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        
        if !self.validateInput() {
            return
        }
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
}

extension UltragazUserViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)

        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        
        self.txtCPF.formatPattern = "###.###.###-##"
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        self.lbTitle.text = "telesena_user_title".localized

        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    }
}
