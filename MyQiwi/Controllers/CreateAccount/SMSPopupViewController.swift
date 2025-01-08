//
//  SMSPopupViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class SMSPopupViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var btnSendSMS: UIButton!
    @IBOutlet weak var btnValid: UIButton!
    
    @IBOutlet weak var lblConfirmation: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewCard: UICardView!
    
    @IBOutlet weak var txtSMS: MaterialField!
    
    // MARK: Variables
    lazy var userRN = UserRN(delegate: self)
    var registerId = 0
    
    // MARK: Ciclo de vida
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        self.startAnimate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions
extension SMSPopupViewController {
    
    @IBAction func openSendSMS(sender: UIButton) {
        Util.showLoading(self) {
            self.userRN.sendSMSRegister(registerId: self.registerId)
        }
    }
    
    @IBAction func openValid(sender: UIButton) {
        
        if self.validateSMS() {
            Util.showLoading(self) {
                let sms = self.txtSMS.text
                self.userRN.validateSMSForRegister(sender: self, activationCod: sms!, registerId: self.registerId)
            }
        }
    }
    
    func validateSMS() -> Bool {
        
        guard let text = self.txtSMS.text else {
            return false
        }

        if text.isEmpty {
            Util.showAlertDefaultOK(self, message: "register_sms_invalid_code".localized)
            return false
        }
        
        return true
    }
}

// MARK: SetupUI
extension SMSPopupViewController: SetupUI {
    
    func setupUI() {

        Theme.default.greenButton(self.btnValid)
        Theme.default.orageButton(self.btnSendSMS)
        
        Theme.default.textAsListTitle(self.lblConfirmation)
        Theme.default.textAsListTitle(self.lblMessage)
    }
    
    func setupTexts() {
        
        self.btnSendSMS.setTitle("register_sms_resend".localized, for: .normal)
        self.btnValid.setTitle("register_sms_validate".localized, for: .normal)
        
        self.lblConfirmation.text = "register_sms_title".localized
        self.lblMessage.text = "register_sms_text_welcome".localized
            .replacingOccurrences(of: "{number}", with: CreateAccountForm.shared.phone)
        self.txtSMS.placeholder = "register_sms_hint".localized
        
        Util.setTextBarIn(self, title: "")
    }
}

// MARK: View Animate
extension SMSPopupViewController {
    
    func startAnimate() {
        
        self.viewBackground.alpha = 0
        self.viewCard.alpha = 0
        
        let translationY = self.viewBackground.frame.height
        self.viewCard.transform = CGAffineTransform(translationX: 0, y: translationY)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {

            self.viewBackground.alpha = 0.8

        }) { _ in

            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {

                self.viewCard.alpha = 1
                self.viewCard.transform = .identity
            })
        }
    }
}

extension SMSPopupViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if param == Param.Contact.USER_SEND_SMS {
                self.dismiss(animated: true, completion: nil)
                
                if result {
                    Util.showAlertDefaultOK(self, message: "register_sms_resent".localized)
                }
                return
            }
            
            if param == Param.Contact.USER_SMS_VALIDATION_REGISTER {
                self.dismiss(animated: true, completion: nil)
                
                if !result {
                    Util.showAlertDefaultOK(self, message: "register_sms_invalid_code".localized)
                    self.txtSMS.text = ""
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.performSegue(withIdentifier: Constants.Segues.FORM_WELCOME, sender: nil)
                }
            }
        }
    }
}
