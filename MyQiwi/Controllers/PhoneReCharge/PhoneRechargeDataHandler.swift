//
//  PhoneRechargeDataHandler.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import ContactsUI
//import RealmSwift

protocol PhoneRechargeDelegate {
    
    func hideButtonContinue(bool: Bool)
    func reload()
    func changeOperator(name image: String)
    func showPhone(contact: PhoneContact)
    func showOperator(bool: Bool)
    func showFirtStep()
    func showTwoStep()
    func showTreeStep()
    func clearFields()
    func hideViews()
    func goToController(withIdentifier: String)
}

class PhoneRechargeDataHandler {

    var delegatePhoneRecharge: PhoneRechargeDelegate?
    var phones: [PhoneContact] = []
    lazy var phoneRechargeRN = PhoneRechargeRN(delegate: self)
    lazy var contactsRN = ContactsRN(delegate: self)
    var stepSelectPhoneRecharge = Constants.StepSelectPhoneRecharge.INSERT_PHONE
    var isEditingOperator = false
    var phoneContact = PhoneContact()
    
    // MARK:
    
    func selectOperator(_ operadora: Operator) {
        
        // Cancelar edição da operadora
        self.isEditingOperator = false
        
        // Atualizar operadora
        QiwiOrder.phoneContactSelected?.op = operadora.getSampleName()
        self.delegatePhoneRecharge?.changeOperator(name: operadora.getSampleName())
        
        Log.print(operadora.name, typePrint: .alert)
        self.delegatePhoneRecharge?.changeOperator(name: operadora.imagePath)
    }
    
    func contactPicker(contact: CNContact) {
        
        self.stepSelectPhoneRecharge = .INSERT_PHONE
        self.changeLayout()
        
        let phoneContact = Util.phoneContactFormat(contact)
        
        if phoneContact.ddd.isEmpty {
            self.phoneContact = phoneContact
            self.showDDDInputDialog()
            return
        }
        
        self.delegatePhoneRecharge?.showPhone(contact: phoneContact)
        self.delegatePhoneRecharge?.hideButtonContinue(bool: false)
    }
    
    func showDDDInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        
        let desc = "ddd_alert_desc".localized.replacingOccurrences(of: "{number}", with: self.phoneContact.number)
        let alertController = UIAlertController(title: "ddd_alert_title".localized, message: desc, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Continuar", style: .default) { (_) in
            
            //getting the input values from user
            var ddd = alertController.textFields?[0].text
            
            if ddd!.count > 2 {
                ddd = String(ddd!.prefix(2))
            }
            
            self.phoneContact.ddd = ddd!
            self.delegatePhoneRecharge?.showPhone(contact: self.phoneContact)
            self.delegatePhoneRecharge?.hideButtonContinue(bool: false)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "DDD"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        let vc = self.delegatePhoneRecharge as! UIViewController
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func layoutOtherNumber() {
        
        self.stepSelectPhoneRecharge = .INSERT_PHONE
        self.changeLayout()
    }
    
    func continueStep(_ sender: UIViewController) {
        
        // Resetar edição de operadora
        if self.isEditingOperator {
            self.isEditingOperator = false
        }
        
        if !self.validField(sender) {
            return
        }
        
        self.saveContact(contat: QiwiOrder.phoneContactSelected!)
    }
    
    func validField(_ sender: UIViewController) -> Bool {
        
        switch self.stepSelectPhoneRecharge {
            
        case .INSERT_PHONE:
            return self.validadePhone(sender)
        case .SELECT_PHONE:
            return true
        case .SELECT_OPERATOR:
            return true
        }
    }
    
    func validadePhone(_ sender: UIViewController) -> Bool {
        
        if !Util.validadeDD((QiwiOrder.phoneContactSelected?.ddd)!) {
            Util.showAlertDefaultOK(sender, message: "phone_error_ddd".localized)
            return false
        }
        
        if (QiwiOrder.phoneContactSelected?.number.count)! < 8 {
            Util.showAlertDefaultOK(sender, message: "phone_error_number".localized)
            return false
        }
        
        return true
    }
    
    func editPhone(_ sender: UIButton) {

        // Alterar a flag para indicar ediçao
        // e manter o layout,
        // assim que fechar o modal da controller de selecao de operadora
        self.isEditingOperator = true
        
        self.stepSelectPhoneRecharge = .INSERT_PHONE
        self.changeLayout()

        let phoneContact = self.getPhoneContact(at: sender.tag)
        self.delegatePhoneRecharge?.showPhone(contact: phoneContact)
        self.delegatePhoneRecharge?.showOperator(bool: false)
        self.delegatePhoneRecharge?.hideButtonContinue(bool: false)
    }
    
    fileprivate func deletePhone(_ sender: UIButton) {
        
        // Apagar
        let phoneContact = self.getPhoneContact(at: sender.tag)
        self.removeContact(contact: phoneContact)
        
        self.loadContacts()
        
        // Vazio
        if self.phones.isEmpty {
            
            self.stepSelectPhoneRecharge = .INSERT_PHONE
            self.changeLayout()
            return
        }
    }
    
    func openRecharge(_ sender: UIViewController, button: UIButton) {
        
        Util.showAlertSheetRecharge(sender, message: "phone_title_message".localized, actionEdit: {
            
            self.editPhone(button)
            
        }, actionDelete: {
            
            self.deletePhone(button)
        })
    }
    
    func didSelect(at index: Int) {

        let item = self.getPhoneContact(at: index)
        
        if item.op != nil && !item.op!.isEmpty {
            QiwiOrder.checkoutBody.requestPhone = .init()
            QiwiOrder.checkoutBody.requestPhone?.ddd = item.ddd
            QiwiOrder.checkoutBody.requestPhone?.tel = item.number
            
            QiwiOrder.phoneContactSelected = item
            
            //Se ja tem operadora pesquisa se existe
            Util.showLoading(self.delegatePhoneRecharge as! UIViewController) {
                self.phoneRechargeRN.verifyOperator(operatorName: item.op!)
            }
            return
        }
        
        self.stepSelectPhoneRecharge = .INSERT_PHONE
        self.changeLayout()
        
        self.delegatePhoneRecharge?.showPhone(contact: item)
        self.delegatePhoneRecharge?.hideButtonContinue(bool: false)
    }
    
    func showContinue(with phone: String) {
        
        // Ocultar
        if !Util.validadeNumberPhone(phone.removeAllOtherCaracters()) {
            self.delegatePhoneRecharge?.hideButtonContinue(bool: true)
            return
        }
        
        // Mostrar
        self.delegatePhoneRecharge?.hideButtonContinue(bool: false)
    }
    
    // MARK: Methods Add/Remove/Load Phone
    
    func saveContact(contat: PhoneContact) {
        
        //let overContactData = PhoneContact()
        //overContactData.ddd = contat.ddd
        //overContactData.number = contat.number
        //overContactData.name = contat.name
        //overContactData.op = contat.op
        //overContactData.serverpk = contat.serverpk
        
        //let realm = try! Realm()
        //do{
        //    try! Realm().write {
        //        realm.add(overContactData, update: true)
        //    }
        //}
        
        QiwiOrder.checkoutBody.requestPhone = .init()
        QiwiOrder.checkoutBody.requestPhone?.ddd = contat.ddd
        QiwiOrder.checkoutBody.requestPhone?.tel = contat.number
        
        if QiwiOrder.phoneContactSelected!.op != nil && !(QiwiOrder.phoneContactSelected!.op?.isEmpty)! {
            Util.showLoading(self.delegatePhoneRecharge as! UIViewController) {
                self.contactsRN.saveCardOrUpdate(phoneContact: contat)
            }
        } else {
            self.stepSelectPhoneRecharge = .SELECT_OPERATOR
            self.changeLayout()
        }
    }
    
    func removeContact(contact: PhoneContact) {
        
        Util.showLoading(self.delegatePhoneRecharge as! UIViewController) {
            
            self.contactsRN.removeContact(contact: contact)
        }
    }
    
    func loadContacts() {
        
        self.phones = self.contactsRN.getNationalContacts()
        self.delegatePhoneRecharge?.reload()
    }
    
    func needShowList() {
        
        self.loadContacts()
        
        // Selecionando operadora, mantem layout
        if self.isEditingOperator {
            return
        }
        
        // Sem contatos, mudar layout para lista
        if !self.phones.isEmpty {
            self.stepSelectPhoneRecharge = .SELECT_PHONE
        }
        
        self.changeLayout()
    }
    
    func getPhoneContact(at index: Int) -> PhoneContact {
        return self.phones[index]
    }
    
    func changeLayout() {
        
        self.delegatePhoneRecharge?.hideViews()
        
        switch self.stepSelectPhoneRecharge {
            
        case .INSERT_PHONE:
            self.delegatePhoneRecharge?.clearFields()
            self.delegatePhoneRecharge?.showFirtStep()
            break
            
        case .SELECT_PHONE:
            self.delegatePhoneRecharge?.showTwoStep()
            break
            
        case .SELECT_OPERATOR:
            self.delegatePhoneRecharge?.showTreeStep()
            break
        }
    }
    
    func nextStep() {
        
        // Proximo passo
        self.controlStep(number: 1)
    }
    
    func backStep() {
        
        // Voltar passso
        self.controlStep(number: -1)
    }
    
    func controlStep(number: Int) {
        
        // Icrementar / Decrementar
        let currentStep = self.stepSelectPhoneRecharge.rawValue + number
        
        // Novo passo
        if let newStep = Constants.StepSelectPhoneRecharge(rawValue: currentStep) {
            
            // Aplicar passo
            self.stepSelectPhoneRecharge = newStep
            
            // Muda layout
            self.changeLayout()
        }
    }
}

extension PhoneRechargeDataHandler : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if param == Param.Contact.PHONE_RECHARGE_VERIFY_OPERATOR_RESPONSE {
                
                if result {
                    let op = object as! Operator
                    QiwiOrder.checkoutBody.requestPhone?.operatorId = op.id
                    QiwiOrder.setPrvId(prvId: op.prvId)
                    
                    ListGenericViewController.stepListGeneric = .SELECT_OPERATOR_VALUE
                    self.delegatePhoneRecharge?.goToController(withIdentifier: Constants.Segues.LIST_GENERIC)
                } else {
                    
                }
            }
            
            //Quando chegar a resposta de insercao do telefone nos ervidor/banco
            if param == Param.Contact.PHONE_RECHARGE_INSERT_PHONE_RESPONSE {
                (self.delegatePhoneRecharge as! UIViewController).dismiss(animated: true, completion: nil)
                
                //Se ja tem operadora pesquisa se existe
                Util.showLoading(self.delegatePhoneRecharge as! UIViewController) {
                    self.phoneRechargeRN.verifyOperator(operatorName: QiwiOrder.phoneContactSelected!.op!)
                }
            }
            
            if param == Param.Contact.PHONE_RECHARGE_DELETE_PHONE_RESPONSE {
                (self.delegatePhoneRecharge as! UIViewController).dismiss(animated: true, completion: nil)
                self.loadContacts()
            }
        }
    }
}

