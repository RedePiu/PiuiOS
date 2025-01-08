//
//  TelesenaPrepagoViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class TelesenaPrepagoViewController: UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtPhone: MaterialField!
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK : INIT
    override func setupViewDidLoad() {
        super.setupViewDidLoad()
        
        self.setupUI()
        self.setupTexts()
    }
}

extension TelesenaPrepagoViewController {
    
    @IBAction func onClickContinue(_ sender: Any) {
        if !self.validateInput() {
            Util.showAlertDefaultOK(self, message: "telesena_prepago_invalid_data".localized)
            return
        }
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
}

extension TelesenaPrepagoViewController {
    
    func validateInput() -> Bool {
        let phone = self.txtPhone.text ?? ""
        let cpf = self.txtCPF.text ?? ""
        
        if phone.isEmpty {
            return false
        }
        
        if !cpf.isValidCPF {
            return false
        }

        QiwiOrder.checkoutBody.requestTelesena?.phone = phone.removeAllOtherCaracters()
        QiwiOrder.checkoutBody.requestTelesena?.cpf = cpf.removeAllOtherCaracters()
        
        return true
    }
}

extension TelesenaPrepagoViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        
        self.txtPhone.formatPattern = "(##) #####-####"
        self.txtCPF.formatPattern = "###.###.###-##"
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        self.lbTitle.text = "ultragaz_user_title".localized

        self.btnBack.setTitle("back".localized, for: .normal)
        
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    }
}
