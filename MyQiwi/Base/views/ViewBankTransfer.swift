//
//  ViewBankTransfer.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import JMMaskTextField_Swift

class ViewBankTransfer: LoadBaseView {

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var imgIconBank: UIImageView!
    @IBOutlet weak var lbLabelInfoBank: UILabel!
    @IBOutlet weak var txtOwnerName: MaterialField!
    @IBOutlet weak var txtCPF: MaterialField!
    @IBOutlet weak var txtAgency: MaterialField!
    @IBOutlet weak var txtAccount: MaterialField!
    @IBOutlet weak var txtDigit: MaterialField!
    @IBOutlet weak var txtNickname: MaterialField!
    @IBOutlet weak var svMainContainer: UIStackView!
    @IBOutlet weak var svAddBank: UIStackView!
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var btnUseOther: UIButton!
    @IBOutlet weak var viewCheckout: ViewCheckbox!

    // MARK: Variables
    var mCurrentBank: Bank?
    var mSelectedBank: BankRequest?
    var mBanks: [BankRequest] = []
    let height = CGFloat(50)
    lazy var mUser = UserRN(delegate: self)
    lazy var mPaymentRN = PaymentRN(delegate: self)
    var delegate: BaseDelegate?
    var isEditingTableView = false
    var viewController: UIBaseViewController?
    var isQiwiOrder = true

    let maskTextField = JMMaskTextField(frame: CGRect.zero)

    let cpf = Constants.FormatPattern.Default.CPF.rawValue
    let cnpj = Constants.FormatPattern.Default.CNPJ.rawValue

    // MARK: Init

    override func initCoder() {
        self.loadNib(name: "ViewBankTransfer")
        self.setupNib()
        self.setupViewNeedBank()
        self.setupTextFields()
        self.viewDidAppear()
    }

    func viewDidAppear() {
    }

    @IBAction func onClickUseOther(_ sender: Any) {
        svMainContainer.isHidden = true
        svAddBank.isHidden = false
        
//        self.txtAgency.becomeFirstResponder()
//        self.txtAgency.keyboardType = UIKeyboardType.numberPad
    }
}

// MARK: Setup
extension ViewBankTransfer {

    func setupViewNeedBank() {

        self.btnFinish.addTarget(self, action: #selector(onClickFinish), for: .touchUpInside)
        
        self.imgIconBank.setupOrage()
        self.lbLabelInfoBank.setupTitleMedium()

        self.lbLabelInfoBank.text = "checkout_bank_card_title".localized
        self.txtOwnerName.placeholder = "checkout_bank_owner_name_hint".localized
        self.txtCPF.placeholder = "checkout_bank_owner_CPF_hint".localized
        self.txtAgency.placeholder = "checkout_bank_owner_agency_hint".localized
        self.txtAccount.placeholder = "checkout_bank_owner_account_hint".localized
        self.txtDigit.placeholder = "checkout_bank_owner_account_digit_hint".localized
        self.txtNickname.placeholder = "checkout_bank_owner_nickiname".localized

        self.txtAgency.addTarget(self, action: #selector(changeAgency(_:)), for: .editingChanged)
        self.txtAccount.addTarget(self, action: #selector(changeAccount(_:)), for: .editingChanged)
    }

    func setupTextFields() {
        //self.txtCPF.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        self.txtAgency.formatPattern = Constants.FormatPattern.Bank.AGENCY.rawValue
        //self.txtAccount.formatPattern = Constants.FormatPattern.Bank.ACCOUNT.rawValue
        //self.txtDigit.formatPattern = Constants.FormatPattern.Bank.DIGIT.rawValue

        Theme.default.greenButton(btnFinish)
        Theme.default.blueButton(btnUseOther)
    }

    func setupNib() {
        self.tableView.register(ViewUserBankCell.nib(), forCellReuseIdentifier: "Cell")
    }

    func setupHeightTable() {
        self.heightTable.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            //self.view.layoutIfNeeded()
        }
    }

    func setBank(bank: Bank) {
        mCurrentBank = bank

        self.loadList()

        if !isBradesco() {
            txtOwnerName.isHidden = true
        }

        if !isSantander() {
            txtCPF.isHidden = true
            return
        }

        if self.isItau() {
            self.txtAgency.setLenght(4)
            self.txtAccount.setLenght(5)
        }
        else if self.isBancoDoBrasil() {
            self.txtAgency.setLenght(4)
            self.txtAccount.setLenght(11)
        }
        else if self.isSantander() {
            self.txtCPF.addTarget(self, action: #selector(changeCPF(_:)), for: .editingChanged)
        }

        //formatar para cpf
    }
    
    func setIsQiwiOrder(isOrder: Bool) {
        self.isQiwiOrder = isOrder
        
        self.viewCheckout.isHidden = false
        self.txtNickname.isHidden = false
//        self.viewCheckout.isHidden = !self.isQiwiOrder
//        self.txtNickname.isHidden = !self.isQiwiOrder
    }

    @objc func changeCPF(_ textField: UITextField) {

        DispatchQueue.main.async {

            let text = textField.text?.removeAllOtherCaracters()

            if text!.count < 12 {
                textField.text = Util.formatText(text: text!, format: "###.###.###-##")
            } else {
                textField.text = Util.formatText(text: text!, format: "##.###.###/####-##")
            }
        }
    }

    @objc func changeAgency(_ textField: UITextField) {

        DispatchQueue.main.async {

            if !self.isItau() && !self.isBancoDoBrasil() {
                return
            }

            if textField.text!.count >= 4 {
                self.txtAccount.becomeFirstResponder()
            }
        }
    }

    @objc func changeAccount(_ textField: UITextField) {

        DispatchQueue.main.async {

            if self.isItau() {
                if textField.text!.count >= 5 {
                    self.txtDigit.becomeFirstResponder()
                }
            }
        }
    }
}

// MARK: Selector
extension ViewBankTransfer {

    @objc func onClickFinish(sender: UIButton) {
        let bank = self.createBankRequestFromInput()
        
        if bank.bankId == 0 {
            Util.showAlertDefaultOK(self.viewController!, message: "checkout_bank_owner_invalid_input".localized)
            return
        }
        
        self.delegate?.onReceiveData(fromClass: ViewBankTransfer.self, param: Param.Contact.BANK_INPUT_SELECTED, result: true, object: bank)
    }
    
    @objc func bankSelected(sender: UIButton) {
        self.mSelectedBank = self.mBanks[sender.tag]
        let selectedBank = self.mBanks[sender.tag]
        let newBank = BankRequest()
        
        newBank.ownerName = self.isSantander() ? selectedBank.cpf : selectedBank.ownerName
        newBank.bankId = selectedBank.bankId
        newBank.nickname = selectedBank.nickname
        newBank.ownerAccount = selectedBank.ownerAccount
        newBank.ownerAccountDigit = selectedBank.ownerAccountDigit
        newBank.ownerAgency = selectedBank.ownerAgency
        newBank.serverpk = selectedBank.serverpk
        newBank.cpf = ""
        //newBank.save = selectedBank.save

        if self.isQiwiOrder {
            QiwiOrder.checkoutBody.transition?.bankRequest = newBank
        }
        
        if newBank.ownerName.isEmpty && newBank.bankId != ActionFinder.Bank.SANTANDER {
            newBank.ownerName = "Vazio"
        }

        self.delegate?.onReceiveData(fromClass: ViewBankTransfer.self, param: Param.Contact.BANK_SELECTED, result: true, object: newBank )
    }

    @objc func editCard(sender: UIBarButtonItem) {
    }

    @objc func removerCard(sender: UIBarButtonItem) {
        self.mSelectedBank = self.mBanks[sender.tag]
        let selectedBank = self.mBanks[sender.tag]

        self.isEditingTableView = false
        self.resetNavigation()
        Util.showLoading(self.viewController!) {
            BankRN(delegate: self).deleteBank(bankRequest: selectedBank)
        }
    }
}

// MARK: Data Table
extension ViewBankTransfer: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mBanks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ViewUserBankCell

        let index = indexPath.row
        let item = self.mBanks[index]
        cell.item = item

        cell.btnCharge.tag = index
        cell.btnCharge.alpha = 1
        cell.btnCharge.addTarget(self, action: #selector(bankSelected(sender:)), for: .touchUpInside)

        self.setupHeightTable()

        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    private func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    private func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

// MARK: Delegate Table
extension ViewBankTransfer: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.isEditingTableView = true

        self.resetNavigation()
        self.setItensNavigation(indexPath: indexPath)
    }
}

extension ViewBankTransfer {

    func isItau() -> Bool {
        return mCurrentBank?.id == ActionFinder.Bank.ITAU
    }

    func isBradesco() -> Bool {
        return mCurrentBank?.id == ActionFinder.Bank.BRADESCO
    }

    func isSantander() -> Bool {
        return mCurrentBank?.id == ActionFinder.Bank.SANTANDER
    }

    func isBancoDoBrasil() -> Bool {
        return mCurrentBank?.id == ActionFinder.Bank.BANCO_DO_BRASIL
    }

    func isCaixa() -> Bool {
        return mCurrentBank?.id == ActionFinder.Bank.CAIXA
    }
}

extension ViewBankTransfer {

    func getUserBankAccount() -> BankRequest {
        return mSelectedBank!
    }

    func createBankRequestFromInput() -> BankRequest{
        if !validateFields() {
            return BankRequest()
        }

        let bankRequest = BankRequest()
        if !isSantander() {
            bankRequest.ownerName = txtOwnerName.text!
        } else {
            bankRequest.ownerName = txtCPF.text!.removeAllOtherCaracters()
        }

        bankRequest.ownerAgency = txtAgency.text!
        bankRequest.ownerAccount = txtAccount.text!
        bankRequest.ownerAccountDigit = txtDigit.text!
        bankRequest.bankId = (mCurrentBank?.id)!
        bankRequest.nickname = txtNickname.text!
        bankRequest.save = true
        
        if bankRequest.ownerName.isEmpty && bankRequest.bankId != ActionFinder.Bank.SANTANDER {
            bankRequest.ownerName = "Vazio"
        }
        
        return bankRequest
    }

    func validateFields() -> Bool {
        if isBradesco() {
            let name = txtOwnerName.text
            if (name?.isEmpty)! || !(name?.containsSpace())! || (name?.count)! < 4 {
                return false
            }
        }

        if isSantander() {

        }

        if (txtAgency.text?.isEmpty)! {
            return false
        }

        if (txtAccount.text?.isEmpty)! {
            return false
        }

        if (txtDigit.text?.isEmpty)! {
            return false
        }

        return true
    }
}

extension ViewBankTransfer {

    func removeCard(index: Int) {
    }

    func loadList() {
        self.mBanks = mPaymentRN.getSavedBankAccount(bankId: self.mCurrentBank!.id)
        if (!self.mBanks.isEmpty) {
            //criar a lista
            svMainContainer.isHidden = false
            svAddBank.isHidden = true
            self.tableView.reloadData()
        } else {
            svMainContainer.isHidden = true
            svAddBank.isHidden = false
        }
    }
}

// MARK: Actions
extension ViewBankTransfer {

    func resetNavigation() {

        Util.setTextBarIn(self.viewController!, title: "transport_toolbar_title_nav".localized)

        DispatchQueue.main.async {

            let icon = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
            let btnClose = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(self.viewController!.dismissPage(_:)))

            self.viewController!.navigationItem.setRightBarButtonItems([btnClose], animated: true)

            if !self.isEditingTableView {
                for row in 0...self.mBanks.count {
                    let indexPath = IndexPath(row: row, section: 0)
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }

    func setItensNavigation(indexPath: IndexPath) {

//        let btnEditCard = UIBarButtonItem(title: "toolbar_mnu_edit".localized.uppercased(), style: .plain, target: self, action: #selector(editCard(sender:)))
//        btnEditCard.tag = indexPath.row

        let btnRemoveCard = UIBarButtonItem(title: "toolbar_mnu_remove".localized.uppercased(), style: .plain, target: self, action: #selector(removerCard(sender:)))
        btnRemoveCard.tag = indexPath.row

        self.viewController!.navigationItem.title = nil
        self.viewController!.navigationController?.navigationBar.barTintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)

        DispatchQueue.main.async {

            // Set new config
            self.viewController!.navigationItem.setRightBarButtonItems([btnRemoveCard], animated: true)
        }
    }
}

extension ViewBankTransfer: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        if param == Param.Contact.BANK_DELETE_RESPONSE {
            DispatchQueue.main.async {
                self.viewController?.dismiss(animated: true, completion: nil)
                self.loadList()
            }
        }
    }
}
