//
//  TaxaCardCpfViewController.swift
//  MyQiwi
//
//  Created by Daniel Catini on 04/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import UIKit

class TaxaCardCpfViewController: UIBaseViewController {
    
    // MARK: - Properties
    private var newTimer = Timer()
    
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var viewButtons: UIView!
    @IBOutlet weak var btBack: UIButton!
    @IBOutlet weak var btContinue: UIButton!
    
    @IBAction func closeClick(_ sender: Any) {
        self.popPage(sender)
    }
    
    @IBAction func btnContinueClick(_ sender: Any) {
        GetCpfData(valid: true) //recuperar emissorid, pelo Prvid
    }
    
    private lazy var taxaCardRN = TaxaCardRN(delegate: self)
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    private var idEmissor: Int?
    private var userCPF: String?
    private var retrial = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupTexts()
        self.SetPlaceHolder()
        
        if Constants.cpfTaxa == "eu" { //validar se o CPF veio "EU", para usar o CPF vazio
            Constants.cpfTaxa = ""
            GetCpfData(valid: false)
        }
    }
}

// MARK: - Private Functions
private extension TaxaCardCpfViewController {
    func GetCpfData(valid: Bool) {
        let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
        let cpf = self.txtCPF.text ?? ""
        
        self.idEmissor = produtoProdata.id_emissor
        self.userCPF = cpf.removeAllOtherCaracters()
        
        if valid && !Util.validadeCPF(cpf) {
            self.displayAlert(
                title: "Dados Obrigatórios",
                message: "forgot_qiwi_cpf_invalid".localized
            )
        }
        
        Util.showLoading(self)
        
        if Constants.fl_verifica_form {
            print("@! >>> Produto_ProData ", produtoProdata.id_emissor)
            taxaCardRN.getFormsResponses(
                idEmissor: produtoProdata.id_emissor,
                cpf: txtCPF.text!.removeAllOtherCaracters()
            )
        } else {
            print("@! >>> Produto_ProData ", produtoProdata.id_emissor)
            self.taxaCardRN.getCardResponses(
                idEmissor: produtoProdata.id_emissor,
                cpf: txtCPF.text!.removeAllOtherCaracters()
            )
        }
    }
}

extension TaxaCardCpfViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.dismissPage(nil)
            
            switch param {
            case Param.Contact.TAXA_GET_CARD_RESPONSE:
                Util.showLoading(self)
                Constants.cpfTaxa = self.txtCPF.text!.removeAllOtherCaracters()
                self.performSegue(withIdentifier: Constants.Segues.TAXA_LIST_CARD, sender: nil)
            case Param.Contact.TAXA_GET_FORM_RESPONSE:
                if result {
                    Constants.cpfTaxa = self.txtCPF.text!.removeAllOtherCaracters()
                    
                    if self.taxaCardRN.getAllGetForms().isEmpty {
                        self.displayAlert(
                            title: "user_cpf_consult_list_status_error_title".localized,
                            message: "user_cpf_consult_list_status_error_description".localized
                        )
                    } else {
                        self.newTimer.invalidate()
                        pushViewController(ListItemsFactory().start(with: taxaCardRN))
                    }
                }
            default:
                break
            }
        }
    }
}

// MARK: - Setup UI
extension TaxaCardCpfViewController: SetupUI {
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btBack)
        Theme.default.blueButton(self.btContinue)
    }
    
    func SetPlaceHolder() {
        txtCPF.keyboardType = .numberPad
        txtCPF.placeholder = "transport_students_form_user_cpf".localized
        txtCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
    }

    func setupTexts() {
        btContinue.setTitle("continue_label".localized)
        btBack.setTitle("back".localized)
    }

    func setupHeightTable() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func setupTimer() {
        newTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(triggerTimer),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc private func triggerTimer() {
        self.taxaCardRN.getLayoutFormResponses(
            idEmissor: self.produtoProdata.id_emissor,
            id_tipo_formulario_carga: Constants.idTipoCarga,
            via: Constants.viaCarga,
            fl_dependente: false
        )
        print("@! >>> Tentando resgatar Forms... \n Tentativa: \(retrial)")
    }
}
