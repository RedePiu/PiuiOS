//
//  EditPaymentsViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 22/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class EditPaymentsViewController : UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoContent: UILabel!
    @IBOutlet weak var lbListDesc: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var backToHome: UIBarButtonItem!
    
    @IBAction func sendToHome(_ sender: UIButton ) {
        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: Ciclo de Vida
    let height = CGFloat(50)
    lazy var paymentsRN = PaymentRN(delegate: self)
    var banks: [BankRequest] = []
    var selectedBank: BankRequest?
    var isEditingTableView = false
    var isFromPaymentView = false
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        
        // Make an optional call to speed up the subsequent launch of card.io scanning
//        CardIOUtilities.preload()
        
        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
    }
    
    override func setupViewWillAppear() {
        self.requestBankList()
    }
    
    func setupNib() {
        self.tableView.register(ViewUserBankCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        if self.isEditingTableView {
            self.isEditingTableView = false
            self.resetNavigation()
        } else {
            self.dismissPage(sender)
        }
    }
}

extension EditPaymentsViewController {

    func requestBankList() {
        self.showLoading()
        
        self.banks = self.paymentsRN.getAllSavedBankAccount()
        let result = !self.banks.isEmpty
        
        self.viewLoading.isHidden = true
        self.tableView.isHidden = !result
        self.lbListDesc.isHidden = !result
        self.btnAdd.isHidden = false
        self.lbNoContent.isHidden = result
        
        // Mostrar a tabela com os dados
        if result {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}

extension EditPaymentsViewController {
    
    func showLoading() {
        self.viewLoading.isHidden = false
        self.tableView.isHidden = true
        self.lbListDesc.isHidden = true
        self.lbNoContent.isHidden = true
        self.btnAdd.isHidden = true
    }
}

extension EditPaymentsViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.blueButton(self.btnAdd)
        Theme.default.textAsListTitle(self.lbTitle)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "my_banks_toolbar_title".localized)
        self.lbTitle.text = "my_banks_title".localized
        self.lbNoContent.text = "my_banks_no_content".localized
        self.lbListDesc.text = "my_banks_desc".localized
        self.btnAdd.setTitle("my_banks_add_btn".localized)
    }
}

extension EditPaymentsViewController : BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if fromClass == UserRN.self {
                if param == Param.Contact.USER_INFO_RESPONSE {
                    //posteriormente devemos chamar o processo para verificar documentos negados
                    CreditCardRN(delegate: self).getUserCards()
                }
            }
            
            if fromClass == CreditCardRN.self {
                if param == Param.Contact.CREDIT_CARD_LIST_RESPONSE {
                    
                }
                
                if param == Param.Contact.CREDIT_CARD_REMOVE_CARD_RESPONSE {
                    self.showLoading()
                    UserRN(delegate: self).getUserInfo()
                }
            }
        }
    }
}

// MARK: Observer Height Collection
extension EditPaymentsViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightTable.constant = size.height + 20
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                    return
                }
            }
        }
        
        self.setupHeightTable()
    }
}

// MARK: Data Table
extension EditPaymentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.banks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ViewUserBankCell
        
        let index = indexPath.row
        let item = self.banks[index]
        cell.item = item
        
        cell.btnCharge.tag = index
        cell.btnCharge.alpha = 0
        cell.btnCharge.addTarget(self, action: #selector(selectCard(sender:)), for: .touchUpInside)
        
        self.setupHeightTable()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


// MARK: Delegate Table
extension EditPaymentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.isEditingTableView = true
        
        self.resetNavigation()
        self.setItensNavigation(indexPath: indexPath)
    }
}

// MARK: Actions
extension EditPaymentsViewController {
    
    func resetNavigation() {
        
        Util.setTextBarIn(self, title: "credit_card_list_toolbar_title".localized)
        
        DispatchQueue.main.async {
            
            let icon = UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate)
            let btnClose = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(self.dismissPage(_:)))
            
            self.navigationItem.setRightBarButtonItems([btnClose], animated: true)
            
            if !self.isEditingTableView {
                for row in 0...self.banks.count {
                    let indexPath = IndexPath(row: row, section: 0)
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    
    func setItensNavigation(indexPath: IndexPath) {
        
        let btnRemoveCard = UIBarButtonItem(title: "toolbar_mnu_remove".localized.uppercased(), style: .plain, target: self, action: #selector(removerCard(sender:)))
        btnRemoveCard.tag = indexPath.row
        
        self.navigationItem.title = nil
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
        
        DispatchQueue.main.async {
            
            // Set new config
            self.navigationItem.setRightBarButtonItems([btnRemoveCard], animated: true)
        }
    }
}

// MARK: Selector
extension EditPaymentsViewController {
    
    @objc func selectCard(sender: UIButton) {
    }
    
    @objc func removerCard(sender: UIBarButtonItem) {
        
        self.isEditingTableView = false
        
        Util.showAlertYesNo(self, message: "alert_confirm_remove".localized, completionOK: {
            
            DispatchQueue.main.async {
                self.removeCard(index: sender.tag)
                self.resetNavigation()
            }
        })
    }
}

extension EditPaymentsViewController {
    
    func removeCard(index: Int) {
        let bank = self.banks[index]
        
    }
    
    func loadList() {
        self.tableView.reloadData()
    }
    
    func setupHeightTable() {
        self.heightTable.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
