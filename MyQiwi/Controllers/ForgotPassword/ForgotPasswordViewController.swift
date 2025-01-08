//
//  ForgotPasswordViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 15/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var txtPhone: MaterialField!
    @IBOutlet weak var txtCode: MaterialField!
    @IBOutlet weak var txtPassword: MaterialField!
    @IBOutlet weak var txtConfimPassword: MaterialField!

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnResent: UIButton!
    @IBOutlet weak var btnSendSMS: UIButton!
    
    @IBOutlet weak var imgPassword: UIImageView!
    
    @IBOutlet weak var lblTitleCPF: UILabel!
    @IBOutlet weak var lblTitlePassword: UILabel!
    
    @IBOutlet weak var lblWhatPasswordTitle: UILabel!
    @IBOutlet weak var lblWhatPasswordMessage: UILabel!
    
    @IBOutlet weak var lblWhatResentTitle: UILabel!
    @IBOutlet weak var lblWhatResentMessage: UILabel!
    
    @IBOutlet weak var lblStatustTitle: UILabel!
    @IBOutlet weak var lblStatusMessage: UILabel!
    
    @IBOutlet weak var imgStatus: UIImageView!
    
    @IBOutlet weak var viewCardWhatPassword: UIView!
    @IBOutlet weak var viewCardCPF: UIView!
    @IBOutlet weak var viewCardResent: UIView!
    @IBOutlet weak var viewCardPassword: UIView!
    @IBOutlet weak var viewCardStatus: UIView!
    
    // MARK: Variables
    
    lazy var userRN = UserRN(delegate: self)
    static var isChangeAccountPassword = true
    static var needToCloseWhenBack = false
    var stepForgotPassword = Constants.StepForgotPassword.FORM_CPF
    var updatedUsderId = 0

    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
    }
    
    override func setupViewWillAppear() {
        
        self.changeLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions
extension ForgotPasswordViewController {
    
    @IBAction func backButton(sender: Any? = nil) {
        if ForgotPasswordViewController.needToCloseWhenBack {
            ForgotPasswordViewController.needToCloseWhenBack = false
            self.btnClose(nil)
            return
        }
        
        self.popPage()
        ForgotPasswordViewController.needToCloseWhenBack = false
    }
    
    @IBAction func openChangePassword(sender: UIButton) {
        Util.showLoading(self) {
            
            let validation = (self.txtCode.text?.removeAllOtherCaracters())!
            let pass = Util.stringToSh256(string: (self.txtPassword.text)!)
            
            if ForgotPasswordViewController.isChangeAccountPassword {
                self.userRN.changePassword(ForgotPasswordViewController.self, sender: self, userId: self.updatedUsderId, validationCode: validation, newPass: pass)
            }
        }
    }
    
    @IBAction func openCancel(sender: UIButton) {
        self.controlStep(number: -1)
    }
    
    @IBAction func openResent(sender: UIButton) {
        Util.showLoading(self) {
            let cpf = (self.txtCPF.text?.removeAllOtherCaracters())!
            let phone = (self.txtPhone.text?.removeAllOtherCaracters())!
            
            if ForgotPasswordViewController.isChangeAccountPassword {
                self.userRN.sendSMSPassword(cpf: cpf, phone: phone, userId: UserRN.getLoggedUserId())
            } else {
                self.userRN.forgotQiwiPassword(cpf: cpf, phone: phone)
            }
        }
    }
    
    @IBAction func openSendSMS(sender: UIButton) {
        Util.showLoading(self) {
            let cpf = (self.txtCPF.text?.removeAllOtherCaracters())!
            let phone = (self.txtPhone.text?.removeAllOtherCaracters())!
            
            if ForgotPasswordViewController.isChangeAccountPassword {
                self.userRN.sendSMSPassword(cpf: cpf, phone: phone, userId: UserRN.getLoggedUserId())
            } else {
                self.userRN.forgotQiwiPassword(cpf: cpf, phone: phone)
            }
        }
    }
}

// MARK: Control UI
extension ForgotPasswordViewController {
    
    func hideAll() {
        
        self.lblTitleCPF.isHidden = true
        self.lblTitlePassword.isHidden = true
        
        self.viewCardWhatPassword.isHidden = true
        self.viewCardCPF.isHidden = true
        self.viewCardResent.isHidden = true
        self.viewCardPassword.isHidden = true
        self.viewCardStatus.isHidden = true
    }
    
    func controlStep(number: Int) {
        
        if self.validFields() {
            let currentStep = self.stepForgotPassword.rawValue + number
            if let newStep = Constants.StepForgotPassword(rawValue: currentStep) {
                self.stepForgotPassword = newStep
                self.changeLayout()
            }
        }
    }
    
    func changeLayout() {
        
        self.hideAll()
        
        switch self.stepForgotPassword {

        case .FORM_CPF:
            self.showCPF()
            break
            
        case .FORM_NEW_PASSWORD:
            self.showNewPassword()
            break
            
        case .FORM_STATUS:
            self.showStatus()
            break
        }
    }
    
    func showCPF() {
        self.viewCardWhatPassword.isHidden = false
        self.lblTitleCPF.isHidden = false
        self.viewCardCPF.isHidden = false
    }
    
    func showNewPassword() {
        self.viewCardResent.isHidden = false
        self.lblTitlePassword.isHidden = false
        self.viewCardPassword.isHidden = false
    }
    
    func showStatus() {
        self.viewCardStatus.isHidden = false
    }
}

extension ForgotPasswordViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            
            if param == Param.Contact.USER_SMS_PASSWORD_SENT {
                if result {
                    self.stepForgotPassword = Constants.StepForgotPassword.FORM_NEW_PASSWORD
                    self.changeLayout()
                    
                    self.updatedUsderId = object as! Int
                } else {
                    self.updatedUsderId = 0
                    Util.showAlertDefaultOK(self, message: "change_pass_sms_failed".localized)
                }
            }
            
            if param == Param.Contact.USER_CHANGE_PASSWORD {
                self.stepForgotPassword = Constants.StepForgotPassword.FORM_STATUS
                self.changeLayout()
                
                if result  {
                    self.imgStatus.image = UIImage(named: "ic_green_done")
                    self.lblStatustTitle.text = "change_pass_sucessed".localized
                    self.lblStatusMessage.text = ForgotPasswordViewController.isChangeAccountPassword ? "change_pass_sucessed_desc".localized : "change_qiwi_pass_sucessed_desc".localized
                    Theme.default.greenButton(self.btnContinue)
                } else {
                    self.imgStatus.image = UIImage(named: "ic_red_error")
                    self.lblStatustTitle.text = "change_pass_failed".localized
                    self.lblStatusMessage.text = "change_pass_failed_desc".localized
                    Theme.default.redButton(self.btnContinue)
                }
            }
        }
    }
}

// MARK: Validades
extension ForgotPasswordViewController {
    
    func validFields() -> Bool {
        
        self.view.endEditing(true)
        
        switch self.stepForgotPassword {
        
        case .FORM_CPF:
            return self.validadeCPF()
        case .FORM_NEW_PASSWORD:
            return ForgotPasswordViewController.isChangeAccountPassword ? self.validadeNewPassword() : self.validadeNewQiwiPasswod()
        case .FORM_STATUS:
            return true
        }
    }
    
    func validadeCPF() -> Bool {
        
        guard let textCPF = self.txtCPF.text else {
            Util.showAlertDefaultOK(self, message: "register_error_cpf".localized)
            return false
        }
        
        guard let phone = self.txtPhone.text else {
            Util.showAlertDefaultOK(self, message: "register_error_phone".localized)
            return false
        }
        
        if !Util.validadeCPF(textCPF) {
            Util.showAlertDefaultOK(self, message: "register_error_cpf".localized)
            return false
        }
        
        if phone.isEmpty {
            Util.showAlertDefaultOK(self, message: "register_error_phone".localized)
            return false
        }
        
        return true
    }
    
    func validadeFields() -> Bool {
        guard let code = self.txtCode.text else {
            Util.showAlertDefaultOK(self, message: "forgot_qiwi_code_incorret".localized)
            return false
        }
        
        if code.isEmpty {
            Util.showAlertDefaultOK(self, message: "forgot_qiwi_code_incorret".localized)
            return false
        }
        
        return true
    }
    
    func validadeNewQiwiPasswod() -> Bool {
        
        if !self.validadeFields() {
            return false
        }
        
        guard let password = self.txtPassword.text else {
            Util.showAlertDefaultOK(self, message: "register_error_qiwi_password".localized)
            return false
        }
        
        guard let confirmPassword = self.txtConfimPassword.text else {
            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
            return false
        }
        
        if !password.isNumeric || password.count != 6 {
            Util.showAlertDefaultOK(self, message: "register_error_qiwi_password".localized)
            return false
        }
        
        if password != confirmPassword {
            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
            return false
        }
        
        return true
    }
    
    func validadeNewPassword() -> Bool {
        
        if !self.validadeFields() {
            return false
        }
        
        guard let password = self.txtPassword.text else {
            Util.showAlertDefaultOK(self, message: "register_error_password".localized)
            return false
        }
        
        guard let confirmPassword = self.txtConfimPassword.text else {
            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
            return false
        }
        
        if !Util.validadePassword(password) {
            Util.showAlertDefaultOK(self, message: "register_error_password".localized)
            return false
        }
        
        if password != confirmPassword {
            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
            return false
        }
        
        return true
    }
}

// MARK: SetupUI
extension ForgotPasswordViewController: SetupUI {
    
    func setupUI() {
        
        self.lblTitleCPF.setupTitleBold()
        self.lblTitlePassword.setupTitleBold()
        
        self.lblWhatPasswordTitle.setupTitleBold()
        self.lblWhatResentTitle.setupTitleBold()
        self.lblStatustTitle.setupTitleBold()
        
        self.lblWhatPasswordMessage.setupMessageMedium()
        self.lblWhatResentMessage.setupMessageMedium()
        self.lblStatusMessage.setupMessageMedium()
        
        if ForgotPasswordViewController.isChangeAccountPassword {
            self.txtPassword.keyboardType = .default
            self.txtConfimPassword.keyboardType = .default
        } else {
            self.txtPassword.keyboardType = .numberPad
            self.txtConfimPassword.keyboardType = .numberPad
        }
        
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnCancel)
        Theme.default.orageButton(self.btnResent)
        
        Theme.default.greenButton(self.btnSendSMS)
        Theme.default.greenButton(self.btnChange)
        Theme.default.greenButton(self.btnContinue)
    }
    
    func setupTexts() {
        
        if ForgotPasswordViewController.isChangeAccountPassword {
            self.imgPassword.image = UIImage(named: "ic_lock")
            
            self.lblWhatPasswordTitle.text = "change_pass_what_is_password".localized
            self.lblWhatPasswordMessage.text = "change_pass_what_is_password_desc".localized
            
            self.lblWhatResentTitle.text = "change_pass_sent".localized
            self.lblWhatResentMessage.text = "change_pass_sent_desc".localized
            
            self.lblStatustTitle.text = "change_pass_sucessed".localized
            self.lblStatusMessage.text = "change_pass_sucessed_desc".localized
            
            Util.setTextBarIn(self, title: "change_pass_toolbar_title_forgot".localized)
        } else {
            self.imgPassword.image = UIImage(named: "ic_red_lock")
            
            self.lblWhatPasswordTitle.text = "register_qiwi_pass_title".localized
            self.lblWhatPasswordMessage.text = "register_qiwi_pass_desc".localized
            
            self.lblWhatResentTitle.text = "change_pass_sent".localized
            self.lblWhatResentMessage.text = "change_pass_sent_desc".localized
            
            self.lblStatustTitle.text = "change_pass_sucessed".localized
            self.lblStatusMessage.text = "change_qiwi_pass_sucessed_desc".localized
            
            Util.setTextBarIn(self, title: "change_qiwi_pass_toolbar_title_forgot".localized)
        }
        
        self.lblTitleCPF.text = "change_pass_account_info_title".localized
        self.lblTitlePassword.text = "change_pass_password_container_title".localized
        
        self.txtCPF.placeholder = "register_cpf".localized
        self.txtPhone.placeholder = "register_phone".localized
        
        self.txtCode.placeholder = "change_pass_sms_hint".localized
        self.txtPassword.placeholder = "change_pass_new_pass".localized
        self.txtConfimPassword.placeholder = "change_pass_new_pass_confirm".localized
        
        self.btnCancel.setTitle("cancel".localized, for: .normal)
        self.btnResent.setTitle("change_pass_resent".localized, for: .normal)
        self.btnSendSMS.setTitle("change_pass_send_sms_button".localized, for: .normal)
        self.btnChange.setTitle("change_pass_change_button".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    }
    
    func setupTextFields() {
        
        self.txtPhone.formatPattern = Constants.FormatPattern.Cell.ddPhone.rawValue
        self.txtCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        
        self.txtPassword.isSecureTextEntry = PassVisibility.isHidden()
        self.txtConfimPassword.isSecureTextEntry = PassVisibility.isHidden()
        
        self.txtPassword.isVisibleRightView = false
        self.txtConfimPassword.isVisibleRightView = false
        
        self.txtPassword.rightButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        self.txtConfimPassword.rightButton.addTarget(self, action: #selector(showConfirmPassword), for: .touchUpInside)
    }
    
    @objc func showPassword() {
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
        
        PassVisibility.showPopupIfCan(sender: self)
        PassVisibility.setIsHidden(isHidden: self.txtPassword.isSecureTextEntry)
    }
    
    @objc func showConfirmPassword() {
        self.txtConfimPassword.isSecureTextEntry = !self.txtConfimPassword.isSecureTextEntry
        
        PassVisibility.showPopupIfCan(sender: self)
        PassVisibility.setIsHidden(isHidden: self.txtConfimPassword.isSecureTextEntry)
    }
}

