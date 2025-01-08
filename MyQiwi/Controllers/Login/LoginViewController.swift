//
//  LoginViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 15/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class LoginViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var viewWarning: ViewWarning!
    @IBOutlet weak var viewPhone: UICardView!
    @IBOutlet weak var viewPassword: UICardView!
    @IBOutlet weak var viewContinue: ViewContinue!
    
    @IBOutlet weak var txtPhone: MaterialField!
    @IBOutlet weak var txtPassword: MaterialField!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    
    @IBOutlet weak var lbError: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    
    // MARK: Variables
    
    let loginDataHandler = LoginDataHandler()
    var showWarning = false
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
        
        self.loginDataHandler.loginDelegate = self
    }
    
    override func setupViewWillAppear() {
        self.loginDataHandler.changeLayoutStep()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Delegate Login
extension LoginViewController: LoginDelegate {
    
    func closeKeyboard() {
        
        DispatchQueue.main.async { [weak self] in
            self?.view.endEditing(true)
        }
    }
    
    func hideAll() {
        
        DispatchQueue.main.async { [weak self] in
            self?.viewPhone.isHidden = true
            self?.viewPassword.isHidden = true
            self?.lbError.isHidden = true
        }
    }
    
    func showPhoneStep(title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.lbTitle.text = title
            self?.viewPhone.isHidden = false
            self?.viewPassword.isHidden = true
            self?.lbError.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self!.txtPhone.becomeFirstResponder()
            }
        }
    }
    
    func showPasswordStep(title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.lbTitle.text = title
            self?.viewPassword.isHidden = false
            self?.viewPhone.isHidden = true
            
            UserRN.savePhoneNumber(phone: self?.txtPhone.text ?? "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.txtPassword.becomeFirstResponder()
            }
        }
    }
    
    func dismis() {
        DispatchQueue.main.async { [weak self] in
            if let _ = self?.presentingViewController {
                self?.dismiss(animated: false)
                return
            }
            
            self?.dismissPage(nil)
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            if case self = self {
                Util.showAlertDefaultOK(self!, message: message)
            }
        }
    }
    
    func segue(withIdentifier: String) {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: withIdentifier, sender: nil)
        }
    }
    
    func showLoading() {
//        DispatchQueue.main.async { [weak self] in
//            if case self = self {
//                Util.showController(LoadingViewController.self, sender: self!)
//            }
//        }
        Util.showLoading(self)
    }
    
    func startMainScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.backToMainScreen(nil)
        }
    }
}

// MARK: IBActions
extension LoginViewController {
    
    @IBAction func openNext(sender: UIButton) {
        
        self.loginDataHandler.nextStep(self.txtPhone.text, self.txtPassword.text)
    }
    
    @IBAction func openBack(sender: UIButton) {
        
        self.loginDataHandler.backStep()
    }
    
    @IBAction func openForgotPassword(sender: UIButton) {
        
        self.loginDataHandler.openForgotPassword()
    }
    
    @IBAction func openLogin(sender: UIButton) {
        
        self.dropScreen()
        self.view.endEditing(true)
        //self.delayDismiss()
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
        //    self.dismiss(animated: true, completion: nil)
        //})
    }
    
    func dropScreen() {
        if loginDataHandler.validateSteps(self.txtPhone.text, self.txtPassword.text) {
            loginDataHandler.login(self.txtPhone.text, self.txtPassword.text)
            return
        }
    }
    
    func delayDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.view.window?.rootViewController!	.dismiss(animated: true, completion: nil)
        })
    }
}

// MARK: SetupUI

extension LoginViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.blueButton(self.btnNext)
        Theme.default.textAsError(self.lbError)
        
        self.txtPassword.isSecureTextEntry = PassVisibility.isHidden()
        self.txtPassword.isVisibleRightView = false
        self.txtPassword.rightButton.addTarget(self, action: #selector(showPassword), for: .touchUpInside)
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(openBack(sender:)), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(openLogin(sender:)), for: .touchUpInside)
    }
    
    @objc func showPassword() {
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
    }
    
    func setupTexts() {
        
        self.btnNext.setTitle("continue_label".localized, for: .normal)
        self.viewContinue.btnContinue.setTitle("login_login".localized, for: .normal)
        self.btnForgotPassword.setTitle("change_pass".localized, for: .normal)
        
        self.txtPhone.placeholder = "register_phone".localized
        self.txtPassword.placeholder = "login_password".localized
        
        self.viewWarning.backgroundColor = Theme.default.red
        self.viewWarning.lbDesc.text = "register_user_already_exists".localized
        self.viewWarning.isHidden = !showWarning
        
        self.txtPhone.text = UserRN.getLastPhoneNumber()
        
        Util.setTextBarIn(self, title: "login_toolbar_title".localized)
    }
    
    func setupTextFields() {
        /////ad//s/
    }
}

