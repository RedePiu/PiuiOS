//
//  RegisterViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 12/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

// MARK: Saved Information
class CreateAccountForm {
    
    static let shared = CreateAccountForm()
    
    var name: String = ""
    var cpf: String = ""
    var email: String = ""
    var birthday: String = ""
    var phone: String = ""
    
    private init() {
    }
}

class RegisterViewController: UIBaseViewController {

    // MARK: Outlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var txtName: MaterialField!
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var txtEmail: MaterialField!
    @IBOutlet weak var txtBirthday: MaterialField!
    @IBOutlet weak var txtPhone: MaterialField!
    @IBOutlet weak var txtPassword: MaterialField!
    @IBOutlet weak var txtConfirmPassword: MaterialField!
    @IBOutlet weak var txtQiwiPassword: MaterialField!
    @IBOutlet weak var txtConfirmQiwiPassword: MaterialField!
    @IBOutlet weak var cardQiwiPass: UICardView!
    @IBOutlet weak var cardPasswordType: UICardView!
    
    @IBOutlet weak var imgLock: UIImageView!
    @IBOutlet weak var lbPassTitle: UILabel!
    @IBOutlet weak var lbPassDesc: UILabel!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbWarning: UILabel!
    @IBOutlet weak var lbTerms: UILabel!
    
    @IBOutlet weak var bottomButtons: NSLayoutConstraint!
    
    // MARK: Variables
    
    var stepCreateAccount = Constants.StepCreateAccount.FORM_NAME
    let createAccountForm = CreateAccountForm.shared
    let registerBody = RegisterBody()
    var registerId = 0
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func setupViewWillAppear() {
        self.changeLayoutStepCreateAccount()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions
extension RegisterViewController {
    
    @IBAction func openContinue(sender: UIButton) {
        
        if validFields() {
            self.createAccountForm.name = self.txtName.text.unsafelyUnwrapped
            self.createAccountForm.cpf = self.txtCPF.text.unsafelyUnwrapped
            self.createAccountForm.birthday = self.txtBirthday.text.unsafelyUnwrapped
            self.createAccountForm.phone = self.txtPhone.text.unsafelyUnwrapped
            self.createAccountForm.email = self.txtEmail.text.unsafelyUnwrapped
            self.stepControll(number: 1)
        }
    }
    
    @IBAction func openBack(sender: UIButton) {
        
        // Passo inicial
        if self.stepCreateAccount == .FORM_NAME {
            
            // Fecha modal
            self.dismissPage(sender)
            return
        }
        
        // Voltar passo
        self.stepControll(number: -1)
    }
}

// MARK: Selectors
extension RegisterViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        guard let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        // Animation
        UIView.animate(withDuration: TimeInterval(truncating: keyboardAnimationDuration)) {
            self.bottomButtons.constant = keyboardFrame.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {

        guard let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
            return
        }
        
        // Animation
        UIView.animate(withDuration: TimeInterval(truncating: keyboardAnimationDuration)) {
            self.bottomButtons.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: SetupUI
extension RegisterViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsError(self.lbWarning)
        
        Theme.default.orageButton(self.btnBack, radius: 0)
        Theme.default.blueButton(self.btnContinue, radius: 0)
        
        self.txtName.becomeFirstResponder()
    }
    
    func setupTexts() {
        
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    
        let texts = ["register_accept_terms_1".localized, "register_accept_terms_2".localized]
        let hexs = [Constants.Colors.Hex.colorQiwiGrey, Constants.Colors.Hex.colorPrimary]
        self.lbTerms.attributedText = Util.formatAttributedText(texts: texts, hex: hexs)
        
        self.txtName.placeholder = "register_name".localized
        self.txtCPF.placeholder = "register_cpf".localized
        self.txtEmail.placeholder = "register_email".localized
        self.txtBirthday.placeholder = "register_birthday".localized
        self.txtPhone.placeholder = "register_phone".localized
//        self.txtQiwiPassword.placeholder = "register_qiwi_password".localized
//        self.txtConfirmQiwiPassword.placeholder = "register_confirm_qiwi_password".localized
        self.txtPassword.placeholder = "register_password".localized
        self.txtConfirmPassword.placeholder = "register_confirm_password".localized
        
        Util.setTextBarIn(self, title: "register_toolbar_title".localized)
    }
    
    func setupTextFields() {
        
        self.txtPhone.formatPattern = Constants.FormatPattern.Cell.ddPhone.rawValue
        self.txtCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        self.txtBirthday.formatPattern = Constants.FormatPattern.Default.BIRTHDAY.rawValue
        
//        self.txtQiwiPassword.setLenght(6)
//        self.txtConfirmQiwiPassword.setLenght(6)
        
//        self.txtQiwiPassword.isSecureTextEntry = PassVisibility.isHidden()
//        self.txtConfirmQiwiPassword.isSecureTextEntry = PassVisibility.isHidden()
        
//        self.txtQiwiPassword.isVisibleRightView = false
//        self.txtConfirmQiwiPassword.isVisibleRightView = false
        
//        self.txtQiwiPassword.rightButton.addTarget(self, action: #selector(showQiwiPassword), for: .touchUpInside)
//        self.txtConfirmQiwiPassword.rightButton.addTarget(self, action: #selector(showConfirmQiwiPassword), for: .touchUpInside)
        
        self.txtPassword.isSecureTextEntry = PassVisibility.isHidden()
        self.txtConfirmPassword.isSecureTextEntry = PassVisibility.isHidden()
        
        self.txtPassword.isVisibleRightView = false
        self.txtConfirmPassword.isVisibleRightView = false
        
        self.txtPassword.rightButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        self.txtConfirmPassword.rightButton.addTarget(self, action: #selector(showConfirmPassword), for: .touchUpInside)
    }
    
    @objc func showQiwiPassword() {
//        self.txtQiwiPassword.isSecureTextEntry = !self.txtQiwiPassword.isSecureTextEntry
    }
    
    @objc func showConfirmQiwiPassword() {
 //       self.txtConfirmQiwiPassword.isSecureTextEntry = !self.txtConfirmQiwiPassword.isSecureTextEntry
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
extension RegisterViewController {
    
    func stepControll(number: Int) {
        
        let currentStep = self.stepCreateAccount.rawValue + number
        if let step = Constants.StepCreateAccount(rawValue: currentStep) {
            // Iniciar proximo passo para criar conta
            self.stepCreateAccount = step
            self.changeLayoutStepCreateAccount()
        }
    }
    
    func changeLayoutStepCreateAccount() {
        
        self.hideAll()
        
        switch self.stepCreateAccount {
            
        case .FORM_NAME:
            
            self.showNameStep()
            break
            
        case .FORM_CPF:
            
            self.showCPFStep()
            break
            
        case .FORM_EMAIL:
            
            self.showEmailStep()
            break
            
        case .FORM_BIRTHDAY:
            
            self.showBirthdayStep()
            break
            
        case .FORM_PHONE:
            
            self.showPhoneStep()
            break
            
//        case .FORM_QIWI_PASSWORD:
//
//            self.showQiwiPasswordStep()
//            break
            
        case .FORM_PASSWORD:
            
            self.showPasswordStep()
            break
            
        case .FORM_SMS:
            
            // Ajustar este step
            Util.showLoading(self) {
                UserRN(delegate: self).register(registerBody: self.registerBody)
            }
            break
        }
    }
    
    func validFields() -> Bool {
        
        switch self.stepCreateAccount {
            
        case .FORM_NAME:
            
            return self.validateNameStep()
            
        case .FORM_CPF:
            
            return self.validateCPFStep()
            
        case .FORM_EMAIL:
            
            return self.validateEmailStep()
            
        case .FORM_BIRTHDAY:
            
            return self.validateBirthdayStep()
            
        case .FORM_PHONE:
            
            return self.validatePhoneStep()
            
        case .FORM_PASSWORD:
            
            return self.validatePasswordStep()
            
//        case .FORM_QIWI_PASSWORD:
//
//            return self.validateQiwiPasswordStep()
            
        case .FORM_SMS:
            
            return true
        }
    }
    
    func showNameStep() {
        
        // Texto para o contexto
        self.lbTitle.text = "register_step_name".localized
        
        // Resetar Continue
        Theme.default.blueButton(self.btnContinue, radius: 0)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        
        // Change Type Keyboard
        
        self.txtName.superview?.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.txtName.becomeFirstResponder()
        }
    }
    
    func showCPFStep() {
        
        // Texto para o contexto
        self.lbTitle.text = "register_step_cpf".localized
        
        // Change Type Keyboard
        self.txtCPF.superview?.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.txtCPF.becomeFirstResponder()
        }
    }
    
    func showEmailStep() {
        
        // Texto para o contexto
        self.lbTitle.text = "register_step_email".localized
        
        self.txtEmail.superview?.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.txtEmail.becomeFirstResponder()
        }
    }
    
    func showBirthdayStep() {
        
        // Texto para o contexto
        self.lbTitle.text = "register_step_birthday".localized
        
        self.txtBirthday.superview?.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.txtBirthday.becomeFirstResponder()
        }
    }
    
    func showPhoneStep() {
        
        // Texto para o contexto
        self.lbTitle.text = "register_step_phone".localized
        
        self.txtPhone.superview?.isHidden = false
        
        // Resetar Continue
        Theme.default.blueButton(self.btnContinue, radius: 0)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.txtPhone.becomeFirstResponder()
        }
    }
    
    func showPasswordStep() {
        
        // Texto para o contexto
        self.lbTitle.text = "register_step_password".localized
        
        self.imgLock.image = UIImage(named: "ic_lock")
        self.lbPassTitle.text = "register_pass_title".localized
        self.lbPassDesc.text = "register_pass_desc".localized
        self.cardPasswordType.isHidden = false
        
//        Theme.default.blueButton(self.btnContinue, radius: 0)
//        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        Theme.default.greenButton(self.btnContinue, radius: 0)
        self.btnContinue.setTitle("finish".localized, for: .normal)
        self.txtPassword.superview?.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.txtPassword.becomeFirstResponder()
        }
    }
    
    func showQiwiPasswordStep() {
        
        // Texto para o contexto
//        self.lbTitle.text = "register_step_qiwi_password".localized
//
//        self.imgLock.image = UIImage(named: "ic_red_lock")
//        self.lbPassTitle.text = "register_qiwi_pass_title".localized
//        self.lbPassDesc.text = "register_qiwi_pass_desc".localized
//        self.cardPasswordType.isHidden = false
//
//        Theme.default.greenButton(self.btnContinue, radius: 0)
//        self.btnContinue.setTitle("finish".localized, for: .normal)
//        self.txtQiwiPassword.superview?.isHidden = false
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            self.txtQiwiPassword.becomeFirstResponder()
//        }
    }
    
    func showSMSStep() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            // Remove foco das textfields
            self.view.endEditing(true)
            
            // Vai para form de SMS
            self.performSegue(withIdentifier: Constants.Segues.FORM_SMS, sender: nil)
        }
    }
    
    func validateNameStep() -> Bool {
        
        guard let text = self.txtName.text else {
            Util.showAlertDefaultOK(self, message: "register_error_name".localized)
            return false
        }
        
        if !Util.validadeName(text) {
            Util.showAlertDefaultOK(self, message: "register_error_name".localized)
            return false
        }
        
        self.registerBody.name = self.txtName.text!
        return true
    }
    
    func validateCPFStep() -> Bool {
        
        guard let text = self.txtCPF.text else {
            Util.showAlertDefaultOK(self, message: "register_error_cpf".localized)
            return false
        }
        
        if !Util.validadeCPF(text) {
            Util.showAlertDefaultOK(self, message: "register_error_cpf".localized)
            return false
        }
        
        self.registerBody.cpf = (self.txtCPF.text?.removeAllOtherCaracters())!
        return true
    }
    
    func validateEmailStep() -> Bool {
        
        // Remove espacos
        self.txtEmail.text = self.txtEmail.text?.removeSpace()
        
        guard let text = self.txtEmail.text else {
            //Util.showAlertDefaultOK(self, message: "register_error_email".localized)
            return true
        }
        
        //Agora é opcional
        if !UserRN.isEmailAndDateIsNeeded() && text.isEmpty {
            self.registerBody.email = UserRN.generateEmail()
            return true
        }
        
        //Se houver texto, entao validamos o texto
        if !Util.validadeEmail(text) {
            Util.showAlertDefaultOK(self, message: "register_error_email".localized)
            return false
        }
        
        self.registerBody.email = self.txtEmail.text!
        return true
    }
    
    func validateBirthdayStep() -> Bool {
        
        guard let text = self.txtBirthday.text else {
            //Util.showAlertDefaultOK(self, message: "register_error_birthday".localized)
            return true
        }
        
        //Agora é opcional
        if !UserRN.isEmailAndDateIsNeeded() && text.isEmpty {
            self.registerBody.birthday = UserRN.generateDateOfBirth()
            return true
        }
        
        if !Util.validateBirthday(text) {
            Util.showAlertDefaultOK(self, message: "register_error_birthday".localized)
            return false
        }
        
        self.registerBody.birthday = self.txtBirthday.text!
        return true
    }
    
    func validatePhoneStep() -> Bool {
        
        guard let text = self.txtPhone.text else {
            Util.showAlertDefaultOK(self, message: "register_error_phone".localized)
            return false
        }
        
        if !Util.validadePhone(text) {
            Util.showAlertDefaultOK(self, message: "register_error_phone".localized)
            return false
        }
        
        self.registerBody.phoneNumber = (self.txtPhone.text?.removeAllOtherCaracters())!
        return true
    }
    
    func validateQiwiPasswordStep() -> Bool {
        
//        guard let password = self.txtQiwiPassword.text else {
//            Util.showAlertDefaultOK(self, message: "register_error_qiwi_password".localized)
//            return false
//        }
//
//        guard let confirmPassword = self.txtConfirmQiwiPassword.text else {
//            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
//            return false
//        }
//
//        if !password.isNumeric || password.count != 6 {
//            Util.showAlertDefaultOK(self, message: "register_error_qiwi_password".localized)
//            return false
//        }
//
//        if password != confirmPassword {
//            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
//            return false
//        }
        
        return true
    }
    
    func validatePasswordStep() -> Bool {
        
        guard let password = self.txtPassword.text else {
            Util.showAlertDefaultOK(self, message: "register_error_password".localized)
            return false
        }
        
        guard let confirmPassword = self.txtConfirmPassword.text else {
            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
            return false
        }
        
        if !Util.validadePassword(password) {
            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
            return false
        }
        
        if password != confirmPassword {
            Util.showAlertDefaultOK(self, message: "register_error_repeat_password".localized)
            return false
        }
        
        self.lbWarning.text = ""
        self.lbWarning.isHidden = true
        self.registerBody.password = (self.txtPassword.text?.sha256())!
        return true
    }
    
    func hideAll() {
        
        self.txtName.superview?.isHidden = true
        self.txtCPF.superview?.isHidden = true

        self.txtEmail.superview?.isHidden = true
        self.txtBirthday.superview?.isHidden = true
        self.txtPhone.superview?.isHidden = true
        self.cardQiwiPass.isHidden = true
        self.txtPassword.superview?.isHidden = true
        
        self.lbWarning.isHidden = true
        self.cardPasswordType.isHidden = true
    }
}

extension RegisterViewController: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if param == Param.Contact.USER_REGISTER {
                //Remove o loading
                self.dismiss(animated: true, completion: nil)
                
                let response = object as! ServiceResponse<RegisterResponse>
                if !result {

                    if response.body?.cod == ResponseCodes.USER_ALREADY_EXISTS {
                        self.performSegue(withIdentifier: Constants.Segues.LOGIN, sender: nil)
                        return
                    }
                    
                    self.stepCreateAccount = .FORM_PASSWORD
                    self.changeLayoutStepCreateAccount()
                    self.lbWarning.text = response.body?.showMessages()
                    self.lbWarning.isHidden = false
                    return
                }
                
                self.registerId = (response.body?.data?.registerId)!
                self.showSMSStep()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.LOGIN {
            
            // controller que sera apresentada
            if let navVC = segue.destination as? LoginViewController {
                // passa o pedido de order pra frente
                navVC.showWarning = true
            }
        }
        
        if segue.identifier == Constants.Segues.FORM_SMS {
            
            // controller que sera apresentada
            if let navVC = segue.destination as? SMSPopupViewController {
                // passa o pedido de order pra frente
                navVC.registerId = self.registerId
            }
        }
    }
}
