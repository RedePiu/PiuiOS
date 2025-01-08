//
//  PhoneRechargeDataHandler.swift
//  MyQiwi
//

import UIKit
import ContactsUI
//import RealmSwift

protocol InternationalPhoneRechargeDelegate {
    
    func hideButtonContinue(bool: Bool)
    func reload()
    func showPhone(contact: PhoneContact)
    func showFirtStep()
    func showTwoStep()
    func showTreeStep()
    func clearFields()
    func hideViews()
    func goToController(withIdentifier: String)
}

class InternationalPhoneDateHandler {

    var delegatePhoneRecharge: InternationalPhoneRechargeDelegate?
    var phones: [PhoneContact] = []
    lazy var phoneRechargeRN = PhoneRechargeRN(delegate: self)
    lazy var contactsRN = ContactsRN(delegate: self)
    let phoneContactDAO = PhoneContactDAO()
    var stepSelectPhoneRecharge = Constants.StepSelectInternationalPhoneRecharge.INSERT_PHONE
    var phoneContact = PhoneContact()
    
    func contactPicker(contact: CNContact) {
        
        self.stepSelectPhoneRecharge = .INSERT_PHONE
        self.changeLayout()
        
        let phoneContact = Util.phoneContactInternationalFormat(contact)
        self.delegatePhoneRecharge?.showPhone(contact: phoneContact)
        self.delegatePhoneRecharge?.hideButtonContinue(bool: false)
    }
    
    func layoutOtherNumber() {
        
        self.stepSelectPhoneRecharge = .INSERT_PHONE
        self.changeLayout()
    }
    
    func continueStep(_ sender: UIViewController) {
        
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
        }
    }
    
    func validadePhone(_ sender: UIViewController) -> Bool {

        if (QiwiOrder.phoneContactSelected?.number.count)! < 6 {
            Util.showAlertDefaultOK(sender, message: "phone_error_number".localized)
            return false
        }
        
        return true
    }
    
    func editPhone(_ sender: UIButton) {

        // Alterar a flag para indicar ediçao
        // e manter o layout,
        // assim que fechar o modal da controller de selecao de operadora
        
        self.stepSelectPhoneRecharge = .INSERT_PHONE
        self.changeLayout()

        let phoneContact = self.getPhoneContact(at: sender.tag)
        self.delegatePhoneRecharge?.showPhone(contact: phoneContact)
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
        
        if !item.number.isEmpty {
            QiwiOrder.checkoutBody.requestInternationalPhone = .init()
            QiwiOrder.checkoutBody.requestInternationalPhone?.phone = item.number
            
            QiwiOrder.phoneContactSelected = item
            
            //Se ja tem operadora pesquisa se existe
           Util.showLoading(self.delegatePhoneRecharge as! UIViewController) {
               self.phoneRechargeRN.consultInternationalNumber(phone: item.number)
           }
            return
        }
        
        self.stepSelectPhoneRecharge = .INSERT_PHONE
        self.changeLayout()
        
        self.delegatePhoneRecharge?.showPhone(contact: item)
        self.delegatePhoneRecharge?.hideButtonContinue(bool: false)
    }
    
    func showContinue(with phone: String) {
        
        let number = phone.removeAllOtherCaracters()
        if number.isEmpty || number.count < 4 {
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
        
        QiwiOrder.checkoutBody.requestInternationalPhone = .init()
        QiwiOrder.checkoutBody.requestInternationalPhone?.phone = contat.number
        
        Util.showLoading(self.delegatePhoneRecharge as! UIViewController) {
            self.contactsRN.saveCardOrUpdate(phoneContact: contat)
        }
    }
    
    func removeContact(contact: PhoneContact) {
        
        Util.showLoading(self.delegatePhoneRecharge as! UIViewController) {
            
            self.contactsRN.removeContact(contact: contact)
        }
    }
    
    func loadContacts() {
        self.phones = self.phoneContactDAO.getAllInternational()
        self.delegatePhoneRecharge?.reload()
    }
    
    func needShowList() {
        
        self.loadContacts()
        
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
        if let newStep = Constants.StepSelectInternationalPhoneRecharge(rawValue: currentStep) {
            
            // Aplicar passo
            self.stepSelectPhoneRecharge = newStep
            
            // Muda layout
            self.changeLayout()
        }
    }
}

extension InternationalPhoneDateHandler : BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        let vc = (self.delegatePhoneRecharge as! UIBaseViewController)
        vc.doActionAfter(after: 0.3, completion: {
            DispatchQueue.main.async {
                vc.dismiss(animated: true, completion: {
                    if param == Param.Contact.PHONE_INTERNATIONAL_RECHARGE_CONSULT_RESPONSE {
                        
                        //After returns from consulting, goes to list
                        if result {
                            QiwiOrder.internationalPhoneValueList = object as? [InternationalValue]
                            
                            ListGenericViewController.stepListGeneric = .SELECT_VALUE
                            self.delegatePhoneRecharge?.goToController(withIdentifier: Constants.Segues.LIST_GENERIC)
                        } else {
                            Util.showAlertDefaultOK(vc, message: "international_phone_consult_fail".localized)
                        }
                    }
                    
                    //Quando chegar a resposta de insercao do telefone nos ervidor/banco
                    if param == Param.Contact.PHONE_RECHARGE_INSERT_PHONE_RESPONSE {
                        
                        //Se ja tem operadora pesquisa se existe
                        Util.showLoading(self.delegatePhoneRecharge as! UIViewController) {
                            self.phoneRechargeRN.consultInternationalNumber(phone: QiwiOrder.checkoutBody.requestInternationalPhone!.phone)
                        }
                    }
                    
                    if param == Param.Contact.PHONE_RECHARGE_DELETE_PHONE_RESPONSE {
                        self.loadContacts()
                    }
                })
            }
        })
    }
}


