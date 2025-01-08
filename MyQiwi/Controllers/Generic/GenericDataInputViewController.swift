//
//  GenericDataInputViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class GenericDataInputViewController: UIBaseViewController {
    
    // MARK: Ciclo de Vida
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var txtInput: MaterialField!
    @IBOutlet weak var viewContinue: ViewContinue!
    
    // MARK: Variables
    public static var inputType: InputType = .CPF
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        self.txtInput.becomeFirstResponder()
        self.txtInput.keyboardType = GenericDataInputViewController.inputType.getKeyBoardType()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GenericDataInputViewController {
    
    func updateViews() {
        self.lbTitle.text = GenericDataInputViewController.inputType.title()
        self.txtInput.formatPattern = GenericDataInputViewController.inputType.format()
        self.txtInput.text = ""
        
        self.txtInput.becomeFirstResponder()
        self.txtInput.keyboardType = GenericDataInputViewController.inputType.getKeyBoardType()
    }
    
    func validateInput() -> Bool {
        var input = txtInput.text!
        var valid = false
        
        switch GenericDataInputViewController.inputType {
        case .CPF:
            input = input.removeAllOtherCaracters()
            valid = Util.validadeCPF(input)
            
            if valid {
                if QiwiOrder.isCPFConsult() {
                    QiwiOrder.checkoutBody.requestSerasaConsult?.whoWillBeConsulted = input
                }
                else if QiwiOrder.isCNPJConsult() {
                    QiwiOrder.checkoutBody.requestSerasaConsult?.whoIsConsulting = input
                }
                else if QiwiOrder.isRvCharge() {
                    QiwiOrder.checkoutBody.requestRv?.cdSubscriber = input
                }
            }
            
            return valid
            
        case .CNPJ:
            input = input.removeAllOtherCaracters()
            valid = Util.validadeCNPJ(input)
            
            if valid {
                if QiwiOrder.isCNPJConsult() {
                    QiwiOrder.checkoutBody.requestSerasaConsult?.whoWillBeConsulted = input
                }
            }
            
            return valid
            
        case .EMAIL:
            valid = input.isEmail()
            
            if valid {
                if QiwiOrder.isClickBus() {
                    QiwiOrder.checkoutBody.requestClickbus?.buyerEmail = input
                }
            }
            
            return valid
        default:
            return false
        }
    }
    
    func segueForRightScreen() {
        
        switch GenericDataInputViewController.inputType {
        case .CPF:
            if QiwiOrder.isCPFConsult() {
                
                ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
                self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
                return
            }
            
            else if QiwiOrder.isCNPJConsult() {
                
                GenericDataInputViewController.inputType = .CNPJ
                self.updateViews()
                return
            }
            
            else if QiwiOrder.isRvCharge() {
                
                ListGenericViewController.stepListGeneric = .SELECT_VALUE
                self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
                return
            }
            
        case .CNPJ:
            
            if QiwiOrder.isCNPJConsult() {
                ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
                self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
            }
            
            break
            
        case .EMAIL:
            
            if QiwiOrder.isClickBus() {
                ClickBusBaseViewController.forwardStep()
                ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
                self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
            }
            break
        default:
            return
        }
    }
}

extension GenericDataInputViewController {
    
    @IBAction func onClickBackArrow(_ sender: Any? = nil) {
        self.onClickBack()
    }
    
    @objc func onClickBack() {
        
        if QiwiOrder.isClickBus() {
            ClickBusBaseViewController.backwardStep()
        }
        
        self.dismissPage(nil)
    }
    
    @objc func onClickContinue() {
        
        if validateInput() {
            segueForRightScreen()
            return
        }
        
        Util.showAlertDefaultOK(self, message: "generic_content_input_error".localized)
    }
}

extension GenericDataInputViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(onClickContinue), for: .touchUpInside)
    }
    
    func setupTexts() {
        
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        self.updateViews()
    }
}

extension GenericDataInputViewController {
    
    enum InputType: Int {
        case CNPJ = 0
        case CPF
        case NAME
        case DATE_OF_BIRTH
        case EMAIL
        case PHONE
        case CEP
        case STREET
        case NUMBER
        case COMPLEMENT
        case NEIGHBORHOOD
        case CITY
        
        func format() -> String {
            switch (self) {
                case .CNPJ: return "##.###.###/####-##"
                case .CPF: return "###.###.###-##"
                case .DATE_OF_BIRTH: return "##/##/####"
                case .PHONE: return "(##) ##### ####"
                case .CEP: return "#####-###"
                default: return ""
            }
        }
        
        func getKeyBoardType() -> UIKeyboardType {
            switch (self) {
                case .CNPJ: fallthrough
                case .CPF: fallthrough
                case .DATE_OF_BIRTH: fallthrough
                case .CEP: fallthrough
                case .NUMBER: fallthrough
                case .PHONE:
                    return UIKeyboardType.numberPad
                
            default:
                return UIKeyboardType.default
            }
        }
            
        func maxLenght() -> Int {
            switch (self) {
                case .CNPJ: return 18
                case .CPF: return 14
                case .NAME: return 100
                case .DATE_OF_BIRTH: return 10
                case .EMAIL: return 50
                case .PHONE: return 15
                case .CEP: return 9
                case .STREET: return 100
                case .NUMBER: return 30
                case .COMPLEMENT: return 100
                case .NEIGHBORHOOD: return 100
                case .CITY: return 100
            }
        }
                
        func errorMessage() -> String {
            switch (self) {
                case .CNPJ: return "genetic_input_error_cnpj".localized
                case .CPF: return "genetic_input_error_cpf".localized
                case .NAME: return "genetic_input_error_name".localized
                case .DATE_OF_BIRTH: return "genetic_input_error_date_birth".localized
                case .EMAIL: return "genetic_input_error_email".localized
                case .PHONE: return "genetic_input_error_phone".localized
                case .CEP: return "genetic_input_error_cep".localized
                case .STREET: return "genetic_input_error_street".localized
                case .NUMBER: return "genetic_input_error_number".localized
                case .COMPLEMENT: return "genetic_input_error_complement".localized
                case .NEIGHBORHOOD: return "genetic_input_error_neighborhood".localized
                case .CITY: return "genetic_input_error_city".localized
            }
        }
                
        func title() -> String {
            switch (self) {
                case .CNPJ: return "serasa_anti_fraud_cnpj_title".localized
                case .CPF: return "serasa_anti_fraud_cpf_title".localized
                case .NAME: return "serasa_anti_fraud_name_title".localized
                case .DATE_OF_BIRTH: return "serasa_anti_fraud_date_birth_title".localized
                case .EMAIL: return "serasa_anti_fraud_email_title".localized
                case .PHONE: return "serasa_anti_fraud_phone_title".localized
                case .CEP: return "serasa_anti_fraud_cep_title".localized
                case .STREET: return "serasa_anti_fraud_street_title".localized
                case .NUMBER: return "serasa_anti_fraud_street_number_title".localized
                case .COMPLEMENT: return "serasa_anti_fraud_complement_title".localized
                case .NEIGHBORHOOD: return "genetic_input_error_neighborhood".localized
                case .CITY: return "serasa_anti_fraud_city_title".localized
            }
        }
            
        func alternativeTitle() -> String {
            switch (self) {
                case .CPF: return "serasa_anti_fraud_cpf_alternative_title".localized
                case .STREET: return "serasa_anti_fraud_street_alternative_title".localized
                case .NEIGHBORHOOD: return "serasa_anti_fraud_neighborhood_alternative_title".localized
                case .CITY: return "serasa_anti_fraud_city_alternative_title".localized
                default: return ""
            }
        }
    }
}

