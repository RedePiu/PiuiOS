//
//  InternationalPhoneProRechargeViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 01/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class InternationalPhoneProRechargeViewController: UIBaseViewController {
    
    @IBOutlet weak var viewContinue: ViewContinue!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtPhone: MaterialField!
    
    @IBOutlet weak var lbInternationalTitle: UILabel!
    @IBOutlet weak var lbInternationalDesc: UILabel!
    @IBOutlet weak var btnGoNational: UIButton!
    
    
    // MARK: Ciclo de vida
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
        
        QiwiOrder.checkoutBody.requestInternationalPhone = .init()
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
    
    @IBAction func onClickGoInternational(_ sender: Any) {
        QiwiOrder.clearFields()
        
        QiwiOrder.setPrvId(prvId: 0)
        QiwiOrder.productName = "phone_product_name".localized
        //self.performSegue(withIdentifier: Constants.Segues.PHONE_RECHARGE, sender: nil)
        self.openNationalFlow()
    }
    
    func openNationalFlow() {
        weak var presentingViewController = self.presentingViewController
        self.dismiss(animated: true, completion: {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "PhoneRechargePro", bundle: nil )
            let nav = storyboard.instantiateViewController(withIdentifier:"PhoneRechargePro") as! UINavigationController
            presentingViewController?.present(nav, animated: true, completion: nil)
        })
    }
}

extension InternationalPhoneProRechargeViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            
            if param == Param.Contact.PHONE_INTERNATIONAL_RECHARGE_CONSULT_RESPONSE {
                self.dismiss(animated: true, completion: nil)
                
                //After returns from consulting, goes to list
                if result {
                    QiwiOrder.internationalPhoneValueList = object as? [InternationalValue]
                    
                    ListGenericViewController.stepListGeneric = .SELECT_VALUE
                    self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
                } else {
                    Util.showAlertDefaultOK(self, message: "international_phone_consult_fail".localized)
                }
            }

        }
    }
}

extension InternationalPhoneProRechargeViewController {
    
    @IBAction func clickBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickContinue() {
        let phone = self.txtPhone.text!.removeAllOtherCaracters()
        QiwiOrder.checkoutBody.requestInternationalPhone?.phone = phone
        
        Util.showLoading(self)
        PhoneRechargeRN(delegate: self).consultInternationalNumber(phone: phone)
    }
}

// MARK: SetupUI
extension InternationalPhoneProRechargeViewController {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.blueButton(self.btnGoNational)
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(clickContinue), for: .touchUpInside)
        
        self.viewContinue.showOnlyBackButton()
        self.txtPhone.becomeFirstResponder()
    }
    
    func setupTexts() {
        
        self.lbTitle.text = "phone_title_label_pro".localized
        self.lbInternationalTitle.text = "international_phone_alert_title".localized
        self.lbInternationalDesc.text = "international_phone_alert_desc".localized
        self.btnGoNational.setTitle("international_phone_alert_click".localized, for: .normal)
        
        self.txtPhone.placeholder = "international_phone_hint_number".localized
        
        Util.setTextBarIn(self, title: "international_phone_title".localized)
    }
    
    func setupTextFields() {
        self.txtPhone.addTarget(self, action: #selector(phoneEditing), for: .editingChanged)
    }
    
    @objc func phoneEditing() {
        if self.txtPhone.text!.removeAllOtherCaracters().count >= 4 {
            self.viewContinue.showBackAndContinueButtons()
        } else {
            self.viewContinue.showOnlyBackButton()
        }
    }
}
