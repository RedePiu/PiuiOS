//
//  ForgotPasswordQiwiViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 06/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ForgotPasswordQiwiViewController: UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnResent: UIButton!
    @IBOutlet weak var btnContinueToChange: UIButton!
    @IBOutlet weak var btChange: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtCode: MaterialField!
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var txtPassword: MaterialField!
    @IBOutlet weak var txtConfirmPassword: MaterialField!
    @IBOutlet weak var lbSMSTitle: UILabel!
    @IBOutlet weak var lbSMSDesc: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbWhatPassTitle: UILabel!
    @IBOutlet weak var lbWhatPassDesc: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var viewStatus: UICardView!
    @IBOutlet weak var viewWhatIsQiwiPass: UICardView!
    @IBOutlet weak var viewSMSSent: UICardView!
    @IBOutlet weak var viewInput: UICardView!
    @IBOutlet weak var viewButtonContinue: UICardView!
    
    // MARK: Variables
    lazy var userRN = UserRN(delegate: self)
    static var toolbarTitle = "forgot_qiwi_pass_toolbar".localized
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
    }
    
    override func setupViewWillAppear() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions

extension ForgotPasswordQiwiViewController {
    
    @IBAction func clickBack(sender: UIButton) {
        
        self.dismissPage(sender)
    }
    
    @IBAction func clickContinue(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickContinueToChange(sender: UIButton) {
        self.showChangePassViews()
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

// MARK: Custom Method
extension ForgotPasswordQiwiViewController {
    
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

// MARK: Control UI
extension ForgotPasswordQiwiViewController {
    
    func hideAll() {
        self.lbTitle.isHidden = true
        self.viewInput.isHidden = true
        self.viewSMSSent.isHidden = true
        self.viewWhatIsQiwiPass.isHidden = true
        self.viewStatus.isHidden = true
        self.viewButtonContinue.isHidden = true
    }
    
    func showInitialViews() {
        self.hideAll()
        
        self.viewWhatIsQiwiPass.isHidden = false
        self.viewButtonContinue.isHidden = false
    }
    
    func showChangePassViews() {
        self.hideAll()
        
        self.lbTitle.isHidden = false
        self.viewInput.isHidden = false
        self.viewSMSSent.isHidden = false
        
        self.requestSMS()
    }
    
    func updateStatus(result: Bool) {
        self.hideAll()
        self.viewStatus.isHidden = false
        
        if result {
            self.imgStatus.image = UIImage(named: "ic_green_done")
            self.lbStatusTitle.text = "forgot_qiwi_status_success_title".localized
            self.lbStatusDesc.text = "forgot_qiwi_status_success_desc".localized
            Theme.default.greenButton(self.btnContinue)
            return
        }
        
        self.imgStatus.image = UIImage(named: "ic_red_error")
        self.lbStatusTitle.text = "forgot_qiwi_status_fail_title".localized
        self.lbStatusDesc.text = "forgot_qiwi_status_fail_desc".localized
        Theme.default.redButton(self.btnContinue)
    }
}

// MARK: Control UI
extension ForgotPasswordQiwiViewController {
    
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

extension ForgotPasswordQiwiViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            
            if param == Param.Contact.USER_SEND_SMS_QIWI_PASSWORD {
                if !result {
                    self.lbSMSTitle.text = "create_qiwi_pass_sent_failed".localized
                    self.lbSMSDesc.text = "create_qiwi_pass_sent_desc_failed".localized
                }
                
                self.lbSMSTitle.text = "create_qiwi_pass_sent".localized
                self.lbSMSDesc.text = "create_qiwi_pass_sent_desc_sucess".localized.replacingOccurrences(of: "{number}", with: UserRN.getLoggedUser().getCensoredCel())
            }
            
            if param == Param.Contact.USER_CHANGE_QIWI_PASSWORD {
                self.dismissPageAfter(after: 0.1)
                self.updateStatus(result: result)
            }
        }
    }
}

// MARK: SetupUI
extension ForgotPasswordQiwiViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnResent)
        Theme.default.greenButton(self.btnContinue)
        Theme.default.greenButton(self.btnContinueToChange)
        Theme.default.orageButton(self.btnCancel)
        Theme.default.greenButton(self.btChange)
        
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsListTitle(self.lbSMSTitle)
        Theme.default.textAsListTitle(self.lbStatusTitle)
        Theme.default.textAsListTitle(self.lbWhatPassTitle)
        
        Theme.default.textAsMessage(self.lbSMSDesc)
        Theme.default.textAsMessage(self.lbStatusDesc)
        Theme.default.textAsMessage(self.lbWhatPassDesc)
        
        self.txtPassword.isSecureTextEntry = PassVisibility.isHidden()
        self.txtConfirmPassword.isSecureTextEntry = PassVisibility.isHidden()
        
        self.txtPassword.isVisibleRightView = false
        self.txtConfirmPassword.isVisibleRightView = false
        
        self.txtPassword.rightButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        self.txtConfirmPassword.rightButton.addTarget(self, action: #selector(showConfirmPassword), for: .touchUpInside)
        
        self.viewStatus.isHidden = true
        
        self.txtCode.setLenght(6)
        self.txtPassword.setLenght(6)
        self.txtConfirmPassword.setLenght(6)
        
        self.txtCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        
        self.showInitialViews()
    }
    
    func setupTexts() {
        
        self.btnResent.setTitle("forgot_qiwi_pass_resent".localized, for: .normal)
        self.btnContinueToChange.setTitle("create_qiwi_pass_continue_to_change".localized, for: .normal)
        
        self.lbTitle.text = "forgot_qiwi_pass_title".localized
        
        self.lbWhatPassTitle.text = "forgot_qiwi_pass_info".localized
        self.lbWhatPassDesc.text = "forgot_qiwi_pass_info_desc".localized
        
        self.lbSMSDesc.text = "create_qiwi_pass_sending_desc".localized
        
        Util.setTextBarIn(self, title: ForgotPasswordQiwiViewController.toolbarTitle)
        ForgotPasswordQiwiViewController.toolbarTitle = "forgot_qiwi_pass_toolbar".localized
    }
    
    func setupTextFields() {
        
        
    }
}
