//
//  DeleteAccountController.swift
//  MyQiwi
//
//  Created by Daniel Catini on 11/09/23.
//  Copyright © 2023 Qiwi. All rights reserved.
//

import UIKit
import JMMaskTextField_Swift

protocol DeleteAccountDelegate {
    
    func delayDismiss() 
    func showAlert(message: String)
    func dismis()
    func closeKeyboard()
    func segue(withIdentifier: String)
    func showLoading()
    func startMainScreen()
}

class DeleteAccountController: UIBaseViewController, DeleteAccountDelegate{
    func delayDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.view.window?.rootViewController!    .dismiss(animated: true, completion: nil)
        })
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async { [weak self] in
            if case self = self {
                Util.showAlertDefaultOK(self!, message: message)
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
    
    func closeKeyboard() {
        DispatchQueue.main.async { [weak self] in
            self?.view.endEditing(true)
        }
    }
    
    func segue(withIdentifier: String) {
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: withIdentifier, sender: nil)
        }
    }
    
    func showLoading() {
        Util.showLoading(self)
    }
    
    func startMainScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.backToMainScreen(nil)
        }
    }
    
    
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var txtCelular: MaterialField!
    @IBOutlet weak var txtSenha: MaterialField!
    @IBOutlet weak var btnContinuar: UIButton!
    
    var mUserRN: UserRN?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mUserRN = UserRN(delegate: self)
        self.mUserRN?.currentViewController = self
        
        self.txtCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        self.txtCelular.formatPattern =
            Constants.FormatPattern.Cell.ddPhone.rawValue
    }
    
    @IBAction func EnviarCancelamento(_ sender: UIButton) {
        if let deleteBody = validateDelete(textPhone: self.txtCelular.text, textPassword: self.txtSenha.text, textCpf: self.txtCPF.text) {
            //mUserRN.login(loginBody: loginBody)
            Util.showLoading(self)
            self.mUserRN?.delete(deleteBody: deleteBody)
        }
    }
    
    func validateDelete(textPhone: String?, textPassword: String?, textCpf: String?) -> DeleteBody? {
        
        // Extract optional
        guard let txtPhone = textPhone else { return nil }
        guard let pass = textPassword else { return nil }
        guard let txtCpf = textCpf else { return nil }
        
        let phone = txtPhone.removeAllOtherCaracters()
        let cpf = txtCpf.removeAllOtherCaracters()
        
        if phone.count < 11 {
            let alerta = UIAlertController(title: "Erro", message: "login_phone_error".localized,  preferredStyle: UIAlertControllerStyle.alert)
            alerta.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
            }))
            
            self.present(alerta, animated: true, completion: nil)
            return nil
        }
        
        if pass.count < 6 {
            let alerta = UIAlertController(title: "Erro", message: "login_pass_error".localized,  preferredStyle: UIAlertControllerStyle.alert)
            alerta.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
            }))
            
            self.present(alerta, animated: true, completion: nil)
            return nil
        }
        
        let deleteBody = DeleteBody(phoneNumber: phone, password: Util.stringToSh256(string: pass), cpf: cpf)
        return deleteBody
    }
}

extension DeleteAccountController: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        if fromClass == UserRN.self {
            
            if param == Param.Contact.USER_LOGOUT {
                // Remove a tela de loading
                self.dismis()
                
                //Se foi sucesso sai da tela
                if result {
                    self.delayDismiss()
                    return
                }
                
                //Se for falhar, exibe a mensagem de erro
                let msg = object as! String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                    Util.showAlertDefaultOK((self), message: msg)
                })
            }
        }
        
    }
}
