//
//  ResponseConsultViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 13/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ResponseConsultViewController: UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var cvOtherCPF: UICardView!
    @IBOutlet weak var cvOwnCPF: UICardView!
    var menuItemSelected: MenuItem!
    @IBOutlet weak var lbOtherCPF: UILabel!
    @IBOutlet weak var lbMyCPF: UILabel!
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        //self.viewCnpj.isHidden = true
        //self.viewCpf.isHidden = false
    }
}

extension ResponseConsultViewController{
    
    @IBAction func sendToNext(){
        ListGenericViewController.stepListGeneric = .SELECT_VALUE
        performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    @IBAction func onClickOwnCPF(){
        
        Util.showAlertYesNo(
            self,
            message: "credit_analysis_validate_cpf_msg".localized.replacingOccurrences(of: "{cpf}", with: UserRN.getLoggedUser().cpf),
            completionOK: {
                QiwiOrder.checkoutBody.requestSerasaConsult?.whoWillBeConsulted = ""
                ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
                self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
        },
            completionCancel: {
                Util.showAlertDefaultOK(self, message: "credit_analysis_verify_accont".localized)
        })
    }
    
    @IBAction func onClickOtherCPF(){
        GenericDataInputViewController.inputType = .CPF
        self.performSegue(withIdentifier: Constants.Segues.GENERIC_INPUT, sender: nil)
    }
}

extension ResponseConsultViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        Theme.default.textAsListTitle(self.lbTitle)
        

        let gestureOwnCPF = UITapGestureRecognizer(target: self, action:  #selector (self.onClickOwnCPF))
        self.cvOwnCPF.addGestureRecognizer(gestureOwnCPF)
        
        let gestureOtherCPF = UITapGestureRecognizer(target: self, action:  #selector (self.onClickOtherCPF))
        self.cvOtherCPF.addGestureRecognizer(gestureOtherCPF)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "cpf_consult_toolbar_title".localized)
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        
        Util.setTextBarIn(self, title: QiwiOrder.productName)
    }
}
