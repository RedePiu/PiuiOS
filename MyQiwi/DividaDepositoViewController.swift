//
//  DividaDepositoViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividaDepositoViewController : UIBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbTitleInput: UILabel!
    @IBOutlet weak var lbValue: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollection: NSLayoutConstraint!

    // INPUTS
    @IBOutlet weak var viewInput: UICardView!
    @IBOutlet weak var viewAnexo: ViewAnexo!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtInput1: MaterialField!
    @IBOutlet weak var txtInput2: MaterialField!
    @IBOutlet weak var txtInput3: MaterialField!
    @IBOutlet weak var txtInput4: MaterialField!
    @IBOutlet weak var txtValue: MaterialField!
    @IBOutlet weak var viewCaixaEletronico: UIStackView!
    @IBOutlet weak var viewCaixaEletronicoTitle: UIStackView!
    @IBOutlet weak var viewButtons: UICardView!
    @IBOutlet weak var viewOtherDeposits: UIView!

    @IBOutlet weak var viewBocaCaixa: UIStackView!
    @IBOutlet weak var viewBocaCaixaTitle: UIStackView!

    @IBOutlet weak var lbCaixaEletronico: UILabel!
    @IBOutlet weak var lbBocaCaixa: UILabel!

    @IBOutlet weak var lbDepositosComprovantes: UILabel!
    @IBOutlet weak var collectionDepositos: UICollectionView!
    @IBOutlet weak var btnAddOtherDeposito: UIButton!

    @IBOutlet weak var viewBankAccountInfo: ViewBankInfo!
    @IBOutlet weak var viewStatus: UICardView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var btnStatus: UIButton!

    var banks = [MenuItem]()
    var receipts = [DividaReceipt]()
    var selectedBank = Bank()
    var selectedDivida = Divida()
    var bankRequest = BankRequest()
    var comprovanteAdapter: ComprovanteDepositoAdapter?
    var isCaixaEletronico = false

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupCollectionView()

        self.viewAnexo.controller = self
        self.txtValue.addTarget(self, action: #selector(formatCurrency), for: .editingChanged)

        let allBanks = BankDAO().getAll()
        for bank in allBanks {
            self.banks.append(MenuItem(description: bank.bankName, image: String(bank.id), action: bank.id, id: bank.id, data: bank))
        }

        self.collectionView.reloadData()
        self.collectionView.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [.new], context: nil)

        self.changeStep(step: .SELECT_BANK)
    }

    var currentStep = DividaTransferenciaViewController.Steps.SELECT_BANK
    enum Steps: Int {
        case SELECT_BANK = 1
        case INPUT_BANK_ACC
        case SHOW_QIWI_BANK_AND_STATUS
    }
}

extension DividaDepositoViewController {

    func requestDividaPayment() {
        Util.showLoading(self)
        DividaRN(delegate: self).payWithDeposito(bankRequest: self.bankRequest, divida: self.selectedDivida, receipts: self.receipts)
    }
    
    @objc func formatCurrency() {
        self.txtValue.text = self.txtValue.text?.currencyInputFormatting()
    }

    func validadeFields() -> Bool {

        if self.getInput().isEmpty {
            Util.showAlertDefaultOK(self, message: "dividas_deposito_id_error".localized)
            return false
        }
        
        if self.txtValue.text!.isEmpty {
            Util.showAlertDefaultOK(self, message: "dividas_deposito_value_error".localized)
            return false
        }

        if !self.viewAnexo.hasFiles() {
            Util.showAlertDefaultOK(self, message: "dividas_deposito_anexo_error".localized)
            return false
        }

        return true
    }

    func generateBankRequest() -> BankRequest {
        let bankRequest = BankRequest()
        bankRequest.ownerAgency = ""
        bankRequest.ownerAccount = ""
        bankRequest.ownerAccountDigit = ""
        bankRequest.ownerName = "Vazio"
        bankRequest.bankId = self.selectedBank.id

        return bankRequest
    }

    func setStatus(success: Bool) {
        self.changeStep(step: .SHOW_QIWI_BANK_AND_STATUS)
        self.btnStatus.removeTarget(nil, action: nil, for: .allEvents)

        if success {
            self.imgStatus.image = UIImage(named: "ic_clock")?.withRenderingMode(.alwaysTemplate)
            self.imgStatus.tintColor = Theme.default.yellow
            self.lbStatusTitle.text = "dividas_status_title_success".localized
            self.lbStatusDesc.text = "dividas_status_desc_success".localized

            Theme.default.yellowButton(self.btnStatus)
            self.btnStatus.addTarget(self, action: #selector(onClickFinishSuccess), for: .touchUpInside)
        }
        else {
            self.imgStatus.image = UIImage(named: "ic_red_error")
            self.lbStatusTitle.text = "dividas_status_title_failed".localized
            self.lbStatusDesc.text = "dividas_status_desc_failed".localized

            Theme.default.redButton(self.btnStatus)
            self.btnStatus.addTarget(self, action: #selector(onClickFinishFailed), for: .touchUpInside)
        }

//        cell.btnPay.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
    }

}

extension DividaDepositoViewController {

    @IBAction func backButton(_ sender: Any? = nil) {

        if self.currentStep == .SHOW_QIWI_BANK_AND_STATUS {
            self.dismiss(animated: true, completion: nil)
            return
        }

        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    @objc func onClickSend(sender: UIButton) {
        if !self.validadeFields() {
            
            Util.showAlertYesNo(self, message: "dividas_deposito_send_only_attaches".localized, completionOK: {
                //Envia somente a lista anexada
                self.bankRequest = self.generateBankRequest()
                self.requestDividaPayment()
            })
            return
        }
        
        let textPrice = self.txtValue.text?.removeAllCaractersExceptNumbers().removeAllOtherCaracters()
        let valueInt = Double(textPrice!) ?? 1
        let value = Double(valueInt / 100)
        
        //Adiciona os dados que estão na tela na lista antes de enviar
        let receipt = DividaReceipt(code: self.getInput(), value: value, attaches: self.viewAnexo.anexos)
        self.receipts.append(receipt)

        self.bankRequest = self.generateBankRequest()
        self.requestDividaPayment()
    }

    @IBAction func onClickAddOtherDeposito(_ sender: Any) {
        if !self.validadeFields() {
            return
        }

        if self.comprovanteAdapter == nil {
            self.comprovanteAdapter = ComprovanteDepositoAdapter(self, collectionView: collectionDepositos)
        }

        let textPrice = self.txtValue.text?.removeAllCaractersExceptNumbers().removeAllOtherCaracters()
        let valueInt = Double(textPrice!) ?? 1
        let value = Double(valueInt / 100)
        
        let receipt = DividaReceipt(code: self.getInput(), value: value, attaches: self.viewAnexo.anexos)
        self.comprovanteAdapter?.addComprovante(receipt: receipt)
        self.receipts.append(receipt)

        self.txtInput1.text = ""
        self.txtInput2.text = ""
        self.txtInput3.text = ""
        self.txtInput4.text = ""
        self.setInputNames()
        self.txtValue.text = ""
        self.viewAnexo.removeAll()

        self.changeStep(step: .INPUT_BANK_ACC)
    }

    @objc func onClickFinishSuccess(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func onClickFinishFailed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onClickExampleCaixaEletronico(_ sender: Any) {
        self.isCaixaEletronico = true
        
        if self.selectedBank.id == ActionFinder.Bank.ITAU || self.selectedBank.id == ActionFinder.Bank.BRADESCO {
            startMultipleDividaExample()
            return
        }
        
        self.startDividaExample()
    }

    @IBAction func onClickExampleBocaCaixa(_ sender: Any) {
        self.isCaixaEletronico = false
        
        if self.selectedBank.id == ActionFinder.Bank.ITAU || self.selectedBank.id == ActionFinder.Bank.BRADESCO {
            startMultipleDividaExample()
            return
        }
        
        self.startDividaExample()
    }
    
    func startMultipleDividaExample() {
        
        DispatchQueue.main.async {
            Util.showController(DividaMultipleReceiptExamplePopup.self, sender: self, completion: { vc in
                vc.bankId = self.selectedBank.id
                vc.isCaixaEletronico = self.isCaixaEletronico
                vc.setImages()
            })
        }
    }
    
    func startDividaExample() {
        
        DispatchQueue.main.async {
            Util.showController(DepositoExampleViewController.self, sender: self, completion: { vc in
                vc.bankId = self.selectedBank.id
                vc.isCaixaEletronico = self.isCaixaEletronico
                vc.setInputNames()
            })
        }
    }
}

extension DividaDepositoViewController {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.selectedBank = self.banks[indexPath.row].data as! Bank
        self.viewBankAccountInfo.setBankInfo(bank: self.selectedBank, value: DividaDetailViewController.getValueToPay(), isDivida: true, isDeposito: true)

        self.stepForward()
    }
}

extension DividaDepositoViewController {

    func stepForward() {
        let nextStep = self.currentStep.rawValue + 1
        if let newStep = DividaTransferenciaViewController.Steps(rawValue: nextStep) {
            self.changeStep(step: newStep)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func stepBackward() {
        let backStep = self.currentStep.rawValue - 1
        if let newStep = DividaTransferenciaViewController.Steps(rawValue: backStep) {
            self.changeStep(step: newStep)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func hideAll() {
        self.lbTitle.isHidden = true
        self.collectionView.isHidden = true
        self.viewInput.isHidden = true
        self.viewBankAccountInfo.isHidden = true
        self.viewStatus.isHidden = true
        self.lbTitleInput.isHidden = true
        self.viewButtons.isHidden = true;
        self.viewOtherDeposits.isHidden = true;
    }

    func changeStep(step: DividaTransferenciaViewController.Steps) {
        self.currentStep = step
        self.hideAll()

        switch (self.currentStep) {

            case .SELECT_BANK:
                self.lbTitle.isHidden = false
                self.collectionView.isHidden = false

                let topOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                self.scrollView.setContentOffset(topOffset, animated: true)
                break

            case .INPUT_BANK_ACC:
                self.setInputNames()
                self.lbTitle.isHidden = false
                self.lbTitleInput.isHidden = false
                self.viewBankAccountInfo.isHidden = false
                self.viewInput.isHidden = false
                self.viewButtons.isHidden = false

                self.viewOtherDeposits.isHidden = true
                if self.comprovanteAdapter != nil && self.comprovanteAdapter?.receipts.count ?? 0 > 0 {
                    self.viewOtherDeposits.isHidden = false
                }

                break

            case .SHOW_QIWI_BANK_AND_STATUS:
            self.viewStatus.isHidden = false
                break
        }
    }
}

// MARK: Observer Height Collection
extension DividaDepositoViewController {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == #keyPath(UICollectionView.contentSize) {
            if let _ = object as? UICollectionView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightCollection.constant = size.height
                    return
                }
            }
        }
    }
}

// Data Collection
extension DividaDepositoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.banks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! BigImageCell

        let currentItem = self.banks[indexPath.row]
        cell.displayContent(image: currentItem.imageMenu ?? "")

        return cell
    }
}

// MARK: Layout Collection
extension DividaDepositoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (self.collectionView.frame.width - (CGFloat(2) * 10)) / 2, height: 130)
    }
}

extension DividaDepositoViewController : BaseDelegate {

    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {

        DispatchQueue.main.async {

            if fromClass == DividaRN.self {
                if param == Param.Contact.DIVIDA_PAY {
                    self.dismissPageAfter(after: 0.8)
                    self.setStatus(success: result)
                }
            }

            if fromClass == ComprovanteDepositoAdapter.self {
                if param == Param.Contact.LIST_REMOVE_ITEM {
                    self.lbDepositosComprovantes.isHidden = true
                    self.collectionDepositos.isHidden = true
                }
            }
        }
    }
}

extension DividaDepositoViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.DEPOSITO_EXAMPLE {

            // controller que sera apresentada
            if let navVC = segue.destination as? DepositoExampleViewController {
                // passa o pedido de order pra frente
                navVC.bankId = self.selectedBank.id
                navVC.isCaixaEletronico = self.isCaixaEletronico
            }
        }
    }
}

extension DividaDepositoViewController {

    func setInputNames() {

        self.viewCaixaEletronico.isHidden = false
        self.viewCaixaEletronicoTitle.isHidden = false
        self.viewBocaCaixa.isHidden = false
        self.viewBocaCaixaTitle.isHidden = false

        switch self.selectedBank.id {
            case ActionFinder.Bank.ITAU:
                //Caixa Eletronico
                self.txtInput1.placeholder = "Agência"
                self.txtInput2.isHidden = true
                //Boca do caixa
                self.txtInput3.placeholder = "Identificação"
                self.txtInput4.isHidden = true
            break

            case ActionFinder.Bank.BRADESCO:
                //Caixa Eletronico
                self.txtInput1.placeholder = "Terminal"
                self.txtInput2.placeholder = "N. Transação"

                //Boca do caixa
                self.txtInput3.placeholder = "Terminal"
                self.txtInput4.placeholder = "Agência"
            break

            case ActionFinder.Bank.SANTANDER:
                //Caixa Eletronico
                self.txtInput1.placeholder = "Dcto"
                self.txtInput2.isHidden = true
                //Boca do caixa
                self.viewBocaCaixa.isHidden = true
                self.viewBocaCaixaTitle.isHidden = true
            break

            case ActionFinder.Bank.BANCO_DO_BRASIL:
                //Caixa Eletronico
                self.txtInput1.placeholder = "N. Documento"
                self.txtInput2.isHidden = true
                //Boca do caixa
                self.txtInput3.placeholder = "N. Documento"
                self.txtInput4.isHidden = true
            break

        default:
            self.txtInput1.placeholder = "Código de identificação"
        }
    }

    func getInput() -> String {
        switch self.selectedBank.id {
            case ActionFinder.Bank.ITAU:
                return self.txtInput1.text! + self.txtInput3.text!

            case ActionFinder.Bank.BRADESCO:
                if !self.txtInput1.text!.isEmpty {
                    return self.txtInput1.text! + self.txtInput2.text!
                } else {
                    return self.txtInput3.text! + self.txtInput4.text!
                }

            case ActionFinder.Bank.SANTANDER:
                return self.txtInput1.text!

            case ActionFinder.Bank.BANCO_DO_BRASIL:
                return self.txtInput1.text! + self.txtInput3.text!

        default:
            return self.txtInput1.text!
        }
    }
}

extension DividaDepositoViewController {

    @objc func txt1Changed(_ textField: UITextField) {
        if self.selectedBank.id == ActionFinder.Bank.SANTANDER {
            return
        }

        self.viewBocaCaixa.isHidden = !self.txtInput1.text!.isEmpty
        self.viewBocaCaixaTitle.isHidden = !self.txtInput1.text!.isEmpty
    }

    @objc func txt2Changed(_ textField: UITextField) {
        self.viewBocaCaixa.isHidden = !self.txtInput2.text!.isEmpty
        self.viewBocaCaixaTitle.isHidden = !self.txtInput2.text!.isEmpty
    }

    @objc func txt3Changed(_ textField: UITextField) {
        self.viewCaixaEletronico.isHidden = !self.txtInput3.text!.isEmpty
        self.viewCaixaEletronicoTitle.isHidden = !self.txtInput3.text!.isEmpty
    }

    @objc func txt4Changed(_ textField: UITextField) {
        self.viewCaixaEletronico.isHidden = !self.txtInput4.text!.isEmpty
        self.viewCaixaEletronicoTitle.isHidden = !self.txtInput4.text!.isEmpty
    }
}

extension DividaDepositoViewController : SetupUI {

    func setupUI() {
        Theme.default.backgroundCard(self)

        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsListTitle(self.lbTitleInput)
        Theme.default.textAsListTitle(self.lbDepositosComprovantes)
        Theme.default.orageButton(self.btnAddOtherDeposito)
        Theme.default.blueButton(self.btnSend)

        self.btnSend.addTarget(self, action: #selector(onClickSend), for: .touchUpInside)

        self.txtInput1.addTarget(self, action: #selector(txt1Changed(_:)), for: UIControl.Event.editingChanged)
        self.txtInput2.addTarget(self, action: #selector(txt2Changed(_:)), for: UIControl.Event.editingChanged)
        self.txtInput3.addTarget(self, action: #selector(txt3Changed(_:)), for: UIControl.Event.editingChanged)
        self.txtInput4.addTarget(self, action: #selector(txt4Changed(_:)), for: UIControl.Event.editingChanged)
    }

    func setupTexts() {
        Util.setTextBarIn(self, title: "dividas_toolbar_title".localized)

        self.lbTitle.text = "dividas_deposito_title".localized
        self.lbTitleInput.text = "dividas_deposito_input_title".localized

        self.viewAnexo.setName(name: "dividas_deposito_receipt".localized)
    }

    func setupCollectionView() {

        //  Cell custom
        self.collectionView.register(BigImageCell.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = false
    }
}
