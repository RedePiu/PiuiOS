//
//  PhoneRechargeProViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class PhoneRechargeProViewController: UIBaseViewController {
    
    @IBOutlet weak var viewContinue: ViewContinue!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtDDD: MaterialField!
    @IBOutlet weak var txtPhone: MaterialField!
    
    @IBOutlet weak var lbNationalTitle: UILabel!
    @IBOutlet weak var lbNationalDesc: UILabel!
    @IBOutlet weak var btnGoInternational: UIButton!
    
    // MARK: Ciclo de vida
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
        
        QiwiOrder.checkoutBody.requestPhone = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViewWillAppear() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PhoneRechargeProViewController {
    
}

extension PhoneRechargeProViewController {
    
    @IBAction func clickBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickContinue() {
        QiwiOrder.checkoutBody.requestPhone?.ddd = self.txtDDD.text!
        QiwiOrder.checkoutBody.requestPhone?.tel = self.txtPhone.text!.removeAllOtherCaracters()
        
        ListGenericViewController.stepListGeneric = .SELECT_OPERATOR
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    @IBAction func onClickGoInternational(_ sender: Any) {
        QiwiOrder.clearFields()
        
        QiwiOrder.setPrvId(prvId: 100167)
        QiwiOrder.productName = "international_phone_title".localized
        //self.performSegue(withIdentifier: Constants.Segues.INTERNATIONAL_PHONE, sender: nil)
        self.openInternationalFlow()
    }
    
    func openInternationalFlow() {
        weak var presentingViewController = self.presentingViewController
        self.dismiss(animated: true, completion: {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "InternationalPhoneProRecharge", bundle: nil )
            let nav = storyboard.instantiateViewController(withIdentifier:"InternationalPhoneProRecharge") as! UINavigationController
            presentingViewController?.present(nav, animated: true, completion: nil)
        })
    }
}

// MARK: SetupUI
extension PhoneRechargeProViewController {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.greenButton(self.btnGoInternational)
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(clickContinue), for: .touchUpInside)
        
        self.viewContinue.showOnlyBackButton()
        self.txtDDD.becomeFirstResponder()
    }
    
    func setupTexts() {
        
        self.lbTitle.text = "phone_title_label_pro".localized
        
        self.lbNationalTitle.text = "national_phone_alert_title".localized
        self.lbNationalDesc.text = "national_phone_alert_desc".localized
        self.btnGoInternational.setTitle("national_phone_alert_click".localized, for: .normal)
        
        Util.setTextBarIn(self, title: "phone_title_recharge".localized)
    }
    
    func setupTextFields() {
        self.txtPhone.setLenght(10)
        self.txtPhone.formatPattern = "#####-####"
        self.txtPhone.addTarget(self, action: #selector(phoneEditing), for: .editingChanged)
        
        self.txtDDD.setLenght(2)
        self.txtDDD.addTarget(self, action: #selector(dddEditing), for: .editingChanged)
    }
    
    @objc func dddEditing() {
        if self.txtDDD.text!.count == 2 {
            
            if self.txtPhone.text!.removeAllOtherCaracters().count < 9 {
                self.txtPhone.becomeFirstResponder()
            } else {
                self.viewContinue.showBackAndContinueButtons()
            }
        } else {
            self.viewContinue.showOnlyBackButton()
        }
    }
    
    @objc func phoneEditing() {
        if self.txtPhone.text!.removeAllOtherCaracters().count >= 9 {
            
            //Se já tem DDD, exibe o botão continuar
            if self.txtDDD.text!.count == 2 {
                self.viewContinue.showBackAndContinueButtons()
            }
            //Se não, joga para digitar o DDD
            else {
                self.txtDDD.becomeFirstResponder()
            }
        } else {
            self.viewContinue.showOnlyBackButton()
        }
    }
}
