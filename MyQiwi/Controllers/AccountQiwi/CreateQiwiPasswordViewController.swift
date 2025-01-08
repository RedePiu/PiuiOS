//
//  CreateQiwiPasswordViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 01/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class CreateQiwiPassword : UIBaseViewController {
    
    // MARK: Outlets
    
    
    // MARK: Variables
    @IBOutlet weak var lbMainText: UILabel!
    @IBOutlet weak var cardInput: UICardView!
    @IBOutlet weak var txtCode: MaterialField!
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var txtPassword: MaterialField!
    @IBOutlet weak var txtConfirmPassword: MaterialField!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lbSMSTitle: UILabel!
    @IBOutlet weak var viewSMS: UICardView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var viewStatus: UICardView!
    @IBOutlet weak var btnClose: UIButton!
    
    lazy var userRN = UserRN(delegate: self)
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        self.requestSMS()
    }
}

// MARK: IBActions

extension CreateQiwiPassword {
    
    func requestSMS() {
        self.lbSMSTitle.text = "create_qiwi_pass_sending".localized
        self.userRN.sendSMSQiwiPassword()
    }
    
    func requestChangePassword() {
        if !self.validateFields() {
            return
        }
        
        let code = self.txtCode.text ?? ""
        let cpf = self.txtCPF.text ?? ""
        let newPass = self.txtPassword.text ?? ""
        
        Util.showLoading(self)
        self.userRN.changeQiwiPassword(cpf: cpf.removeAllOtherCaracters(), validationCode: code, newPass: newPass)
    }
}

extension CreateQiwiPassword {
    
    @IBAction func clickContinue(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickChangePass(sender: UIButton) {
        self.requestChangePassword()
    }
    
    @IBAction func cickResentSMS(sender: UIButton) {
        self.requestSMS()
    }
    
    @objc func showPassword() {
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
        
        PassVisibility.showPopupIfCan(sender: self)
        PassVisibility.setIsHidden(isHidden: self.txtPassword.isSecureTextEntry)
    }
    
    @objc func showConfirmPassword() {
        self.txtConfirmPassword.isSecureTextEntry = !self.txtConfirmPassword.isSecureTextEntry
        
        PassVisibility.showPopupIfCan(sender: self)
        PassVisibility.setIsHidden(isHidden: self.txtConfirmPassword.isSecureTextEntry)
    }
}

// MARK: Control UI
extension CreateQiwiPassword {
    
    func validateFields() -> Bool {
        
        let code = self.txtCode.text ?? ""
        if code.count < 4 {
            Util.showAlertDefaultOK(self, message: "forgot_qiwi_code_invalid".localized)
            return false
        }
        
        let cpf = self.txtCPF.text ?? ""
        if !Util.validadeCPF(cpf.removeAllOtherCaracters()) {
            Util.showAlertDefaultOK(self, message: "forgot_qiwi_cpf_invalid".localized)
            return false
        }
        
        guard let password = self.txtPassword.text else {
            Util.showAlertDefaultOK(self, message: "forgot_qiwi_password_must_be_numeric".localized)
            return false
        }
        
        guard let confirmPassword = self.txtConfirmPassword.text else {
            Util.showAlertDefaultOK(self, message: "forgot_qiwi_password_not_the_same".localized)
            return false
        }
        
        if !password.isNumeric || password.count != 6 {
            Util.showAlertDefaultOK(self, message: "forgot_qiwi_password_must_be_numeric".localized)
            return false
        }
        
        if password != confirmPassword {
            Util.showAlertDefaultOK(self, message: "forgot_qiwi_password_not_the_same".localized)
            return false
        }
        
        return true
    }
}

extension CreateQiwiPassword: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            
            if param == Param.Contact.USER_SEND_SMS_QIWI_PASSWORD {
                if !result {
                    Util.showAlertDefaultOK(self, message: "forgot_qiwi_pass_sms_failed".localized, titleOK: "OK", completionOK: {
                        
                        self.dismissPageAfter(after: 0.3)
                    })
                }
                
                self.lbSMSTitle.text = "create_qiwi_pass_sms_title".localized
            }
            
            if param == Param.Contact.USER_CHANGE_QIWI_PASSWORD {
                self.dismissPageAfter(after: 0.1)
                self.updateStatus(result: result)
            }
        }
    }
}

// MARK: Control UI
extension CreateQiwiPassword {
    
    func updateStatus(result: Bool) {
        self.btnClose.isHidden = true
        self.lbMainText.isHidden = true
        self.cardInput.isHidden = true
        self.viewSMS.isHidden = true
        self.viewStatus.isHidden = false
        
        if result {
            self.imgStatus.image = UIImage(named: "ic_green_done")
            self.lbStatusTitle.text = "forgot_qiwi_status_success_title".localized
            self.lbStatusDesc.text = "forgot_qiwi_status_success_desc".localized
            
            UserRN.setQiwiAccountActive(isActivity: true)
            Theme.default.greenButton(self.btnFinish)
            return
        }
        
        self.imgStatus.image = UIImage(named: "ic_red_error")
        self.lbStatusTitle.text = "forgot_qiwi_status_fail_title".localized
        self.lbStatusDesc.text = "forgot_qiwi_status_fail_desc".localized
        Theme.default.redButton(self.btnFinish)
    }
}

// MARK: SetupUI

extension CreateQiwiPassword {
    
    func setupUI() {
        Theme.default.greenButton(self.btnContinue)
        
        self.txtPassword.isSecureTextEntry = PassVisibility.isHidden()
        self.txtConfirmPassword.isSecureTextEntry = PassVisibility.isHidden()
        
        self.txtPassword.isVisibleRightView = false
        self.txtConfirmPassword.isVisibleRightView = false
        
        self.txtPassword.rightButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        self.txtConfirmPassword.rightButton.addTarget(self, action: #selector(showConfirmPassword), for: .touchUpInside)
        
        self.txtCode.setLenght(6)
        self.txtPassword.setLenght(6)
        self.txtConfirmPassword.setLenght(6)
        
        self.txtCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
    }
    
    func setupTexts() {
        self.lbMainText.text = "create_qiwi_pass_title".localized
        
        self.lbSMSTitle.text = "create_qiwi_pass_sms_title".localized
//        self.lbSMSDesc.text = "forgot_qiwi_pass_sent_desc".localized.replacingOccurrences(of: "{number}", with: UserRN.getLoggedUser().cel)
        
        self.txtCode.placeholder = "create_qiwi_pass_code_holder".localized
        self.txtCPF.placeholder = "create_qiwi_pass_cpf_holder".localized
        self.txtPassword.placeholder = "create_qiwi_pass_pass_holder".localized
        self.txtConfirmPassword.placeholder = "create_qiwi_pass_confirm_pass_holder".localized
        
        self.btnContinue.setTitle("create_qiwi_pass_continue".localized)
        
        //self.btnResend.setTitle("forgot_qiwi_pass_resent".localized, for: .normal)
        Util.setTextBarIn(self, title: "create_qiwi_title_toolbar".localized)
    }
}

