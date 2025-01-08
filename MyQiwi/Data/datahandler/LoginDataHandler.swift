//
//  LoginDataHandler.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 06/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    
    func showAlert(message: String)
    func showPhoneStep(title: String)
    func showPasswordStep(title: String)
    func hideAll()
    func dismis()
    func closeKeyboard()
    func segue(withIdentifier: String)
    func showLoading()
    func startMainScreen()
}

class LoginDataHandler {
    
    // MARK: Variables
    
    var stepLogin = Constants.StepLogin.FORM_PHONE
    var mUserRN: UserRN!
    var loginDelegate: LoginDelegate?
    
    // MARK: Constructor
    
    init() {
        self.mUserRN = UserRN(delegate: self)
    }

    // MARK: Methods
    
    func login(_ textPhone: String?, _ textPassword: String?) {
        
        if let loginBody = validateLogin(textPhone: textPhone, textPassword: textPassword) {
            self.loginDelegate?.closeKeyboard()
            self.loginDelegate?.showLoading()
            mUserRN.login(loginBody: loginBody)
        }
    }
    
    func validateLogin(textPhone: String?, textPassword: String?) -> LoginBody? {
        
        // Extract optional
        guard let txtPhone = textPhone else { return nil }
        guard let pass = textPassword else { return nil }
        
        let phone = txtPhone.removeAllOtherCaracters()
        
        if phone.count < 11 {
            self.loginDelegate?.showAlert(message: "login_phone_error".localized)
            return nil
        }
        
        if pass.count < 6 {
            self.loginDelegate?.showAlert(message: "login_pass_error".localized)
            return nil
        }
        
        let loginBody = LoginBody(phoneNumber: phone, password: Util.stringToSh256(string: pass))
        return loginBody
    }
}

// MARK: Control UI
extension LoginDataHandler {
    
    func nextStep(_ textPhone: String?, _ textPassword: String?) {
        
        if self.validateSteps(textPhone, textPassword) {
            
            // Proximo passo
            self.controllStepLogin(number: 1)
        }
    }
    
    func backStep() {
        
        // Estando no passo inicia
        if self.stepLogin == .FORM_PHONE {
            
            // Fecha modal
            self.loginDelegate?.dismis()
            return
        }
        
        // Passo anterior
        self.controllStepLogin(number: -1)
    }
    
    func controllStepLogin(number: Int) {
        
        // Incrementar / Decrementar
        let nextStep = self.stepLogin.rawValue + number
        
        // Novo passo
        if let currentStep = Constants.StepLogin(rawValue: nextStep) {
            
            // Aplicar
            self.stepLogin = currentStep
            
            // Atualizar
            self.changeLayoutStep()
        }
    }
    
    func changeLayoutStep() {
        
        self.loginDelegate?.closeKeyboard()
        self.loginDelegate?.hideAll()
        
        switch self.stepLogin {
            
        case .FORM_PHONE:
            self.loginDelegate?.showPhoneStep(title: "login_title".localized)
            
        case .FORM_PASSWORD:
            self.loginDelegate?.showPasswordStep(title: "login_logging_access_password".localized)
        }
    }
    
    func validateSteps(_ textPhone: String?, _ textPassword: String?) -> Bool {
        
        switch self.stepLogin {
            
        case .FORM_PHONE:
            return self.validatePhone(txtPhone: textPhone)
            
        case .FORM_PASSWORD:
            return self.validatePassword(txtPassword: textPassword)
        }
    }
    
    func validatePhone(txtPhone: String?) -> Bool {
        
        guard let text = txtPhone else {
            self.loginDelegate?.showAlert(message: "login_phone_error".localized)
            return false
        }
        
        if !Util.validadePhone(text) {
            self.loginDelegate?.showAlert(message: "login_phone_error".localized)
            return false
        }
        
        return true
    }
    
    func validatePassword(txtPassword: String?) -> Bool {
        
        guard let password = txtPassword else {
            self.loginDelegate?.showAlert(message: "login_pass_error".localized)
            return false
        }
        
        if !Util.validadePassword(password) {
            self.loginDelegate?.showAlert(message: "login_pass_error".localized)
            return false
        }
        
        return true
    }
    
    func openForgotPassword() {
        self.loginDelegate?.closeKeyboard()
        
        ForgotPasswordViewController.isChangeAccountPassword = true
        self.loginDelegate?.segue(withIdentifier: Constants.Segues.FORGOT_PASSWORD)
    }
}

extension LoginDataHandler: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            
            if fromClass == UserRN.self && param == Param.Contact.USER_LOGIN {
                
                // Remove a tela de loading
                self.loginDelegate?.dismis()
                
                //Se foi sucesso sai da tela
                if result {
                    (self.loginDelegate as! LoginViewController).delayDismiss()
                    return
                }
                
                //Se for falhar, exibe a mensagem de erro
                let msg = object as! String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    Util.showAlertDefaultOK((self.loginDelegate as! LoginViewController), message: msg)
                })
            }
        }
    }
}
