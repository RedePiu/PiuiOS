//
//  InternationalPhoneRechargeViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 30/03/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit
import ContactsUI

class InternationalPhoneRechargeViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var lbLabelTitle: UILabel!
    @IBOutlet weak var btnOtherNumber: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var imgSelectOperator: UIImageView!
    @IBOutlet weak var btnSelectOperator: UIButton!
    
    @IBOutlet weak var lbInternationalTitle: UILabel!
    @IBOutlet weak var lbInternationalDesc: UILabel!
    @IBOutlet weak var btnGoNational: UIButton!
    
    @IBOutlet var btnAgenda: [UIButton]!
    
    @IBOutlet weak var txtPhone: MaterialField!
    @IBOutlet weak var txtName: MaterialField!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    @IBOutlet weak var viewCardPhone: UIView!
    @IBOutlet weak var viewContinue: UIView!
    @IBOutlet weak var viewAgenda: UIView!
    @IBOutlet weak var viewListContact: UIView!
    @IBOutlet weak var viewSelectOperator: UIView!
    
    
    // MARK: Variables

    let heightRow = CGFloat(60)
    var dataHandler = InternationalPhoneDateHandler()
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTableView()
        self.setupTexts()
        self.setupTextFields()
        
        self.dataHandler.delegatePhoneRecharge = self
        QiwiOrder.phoneContactSelected = PhoneContact()
        
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViewWillAppear() {
        
        self.dataHandler.needShowList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickGoNational(_ sender: Any) {
        QiwiOrder.clearFields()
        
        QiwiOrder.setPrvId(prvId: 0)
        QiwiOrder.productName = "phone_product_name".localized
        self.openNationalFlow()
        //self.performSegue(withIdentifier: Constants.Segues.PHONE_RECHARGE, sender: nil)
    }
    
    func openNationalFlow() {
        weak var presentingViewController = self.presentingViewController
        self.dismiss(animated: true, completion: {
            
            let storyboard: UIStoryboard = UIStoryboard(name: "PhoneRecharge", bundle: nil )
            let nav = storyboard.instantiateViewController(withIdentifier:"PhoneRecharge") as! UINavigationController
            presentingViewController?.present(nav, animated: true, completion: nil)
        })
    }
}
    
// MARK: Observer Height Collection
extension InternationalPhoneRechargeViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightTableView.constant = size.height
                    return
                }
            }
        }
        
        self.heightTableView.constant = self.tableView.contentSize.height
    }
}
    
// MARK: Phone Recharge Delegate
extension InternationalPhoneRechargeViewController: InternationalPhoneRechargeDelegate {
        
    func clearFields() {
        self.clearAll()
    }
    
    func hideViews() {
        self.hideAll()
    }
    
    func hideButtonContinue(bool: Bool) {
        DispatchQueue.main.async {
            self.btnContinue.isHidden = bool
        }
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showPhone(contact: PhoneContact) {
        DispatchQueue.main.async {
            self.txtName.text =  contact.name
            self.txtPhone.text = contact.ddd + contact.number
            
            QiwiOrder.phoneContactSelected = PhoneContact()
            QiwiOrder.phoneContactSelected?.name = contact.name
            QiwiOrder.phoneContactSelected?.number = contact.number
            QiwiOrder.phoneContactSelected?.ddd = "0"
            QiwiOrder.phoneContactSelected?.op = "0"
            QiwiOrder.phoneContactSelected?.serverpk = contact.serverpk
        }
    }
    
    func showFirtStep() {
        self.showInsertPhone()
    }
    
    func showTwoStep() {
        self.showSelectPhone()
    }
    
    func showTreeStep() {
        self.view.endEditing(true)
        ListGenericViewController.stepListGeneric = .SELECT_VALUE
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    func goToController(withIdentifier: String) {
        
        // Verificar se loading controller esta visivel
//        if self.presentedViewController is LoadingViewController {
//            self.dismiss(animated: false) {
//                self.performSegue(withIdentifier: withIdentifier, sender: nil)
//            }
//
//            return
//        }

        DispatchQueue.main.async {
            self.performSegue(withIdentifier: withIdentifier, sender: nil)
        }
    }
}
    
// MARK: IBActions
extension InternationalPhoneRechargeViewController {
    
    @IBAction func openSearch(sender: UIButton) {
    
        self.chooseContact()
    }
    
    @IBAction func openAgenda(sender: UIButton) {
        
        self.chooseContact()
    }
    
    @IBAction func openOtherNumber(sender: UIButton) {
        
        self.dataHandler.layoutOtherNumber()
    }
    
    @IBAction func clickBack(sender: UIButton) {
        
        self.dismissPage(sender)
    }
    
    @IBAction func openContinue(sender: UIButton) {
        
        let name = self.txtName.text ?? ""
        let phone = self.txtPhone.text ?? ""

        QiwiOrder.phoneContactSelected?.number = phone
        QiwiOrder.phoneContactSelected?.name = name
        QiwiOrder.phoneContactSelected?.ddd = "0"
        QiwiOrder.phoneContactSelected?.op = "0"
               
        self.dataHandler.continueStep(self)
    }
        
    @objc func openRecharge(sender: UIButton) {
        self.dataHandler.openRecharge(self, button: sender)
    }
    
    func chooseContact() {
        let cnPicker = CNContactPickerViewController()
        
        cnPicker.delegate = self
        self.present(cnPicker, animated: true)
    }
}
    
// MARK: Controll Steps
extension InternationalPhoneRechargeViewController {
    
    func clearAll() {
        
        DispatchQueue.main.async {
            self.txtPhone.text = ""
            self.txtName.text = ""
        }
    }
    
    func hideAll() {
        
        DispatchQueue.main.async {
            self.viewAgenda.isHidden = true
            self.viewContinue.isHidden = true
            self.viewCardPhone.isHidden = true
            self.viewListContact.isHidden = true
            self.btnContinue.isHidden = true
        }
    }
}
    
// MARK: Show Views
extension InternationalPhoneRechargeViewController {
    
    func showInsertPhone() {
        
        DispatchQueue.main.async {
            self.lbLabelTitle.text = "phone_select_contact".localized
            self.viewCardPhone.isHidden = false
            self.viewContinue.isHidden = false
            self.btnContinue.isHidden = true
            
            self.txtPhone.becomeFirstResponder()
        }
    }
    
    func showSelectPhone() {
        
        DispatchQueue.main.async {
            self.lbLabelTitle.text = "phone_select_contact_fav".localized
            self.viewListContact.isHidden = false
            self.viewAgenda.isHidden = false
        }
    }
}
    
// MARK: Delegate Contact
extension InternationalPhoneRechargeViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dataHandler.contactPicker(contact: contact)
        }
    }
}

// MARK: Data Table
extension InternationalPhoneRechargeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataHandler.phones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! PhoneContactCell
        
        cell.selectionStyle = .none
        
        let index = indexPath.row
        let phoneContact = self.dataHandler.getPhoneContact(at: index)
        
        // Tupla com informações para cell
        cell.item = (phoneContact, index, self, #selector(openRecharge(sender:)))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heightRow
    }
}

// MARK: Delegate Table
extension InternationalPhoneRechargeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dataHandler.didSelect(at: indexPath.row)
    }
}

// MARK: SetupUI
extension InternationalPhoneRechargeViewController {
    
    func setupTableView() {
     
        self.tableView.tableFooterView = UIView()
        self.tableView.layer.masksToBounds = false
        self.tableView.register(PhoneContactCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbLabelTitle)
        Theme.default.blueButton(self.btnOtherNumber)
        Theme.default.greenButton(self.btnContinue)
    
        self.lbInternationalDesc.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        
        self.btnAgenda.forEach { buttonAgenda in
            Theme.default.orageButton(buttonAgenda)
        }
        
        Theme.default.blueButton(self.btnGoNational)
    }
    
    func setupTexts() {
        
        self.lbLabelTitle.text = "phone_select_contact_fav".localized
        self.btnOtherNumber.setTitle("phone_or_tape_contact".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        
        self.lbInternationalTitle.text = "international_phone_alert_title".localized
        self.lbInternationalDesc.text = "international_phone_alert_desc".localized
        self.btnGoNational.setTitle("international_phone_alert_click".localized, for: .normal)
        
        self.btnAgenda.forEach { buttonAgenda in
            buttonAgenda.setTitle("phone_search_contacts".localized, for: .normal)
        }
        
        self.txtPhone.placeholder = "international_phone_hint_number".localized
        self.txtName.placeholder = "phone_hint_name".localized
        
        Util.setTextBarIn(self, title: "international_phone_title".localized)
    }
    
    func setupTextFields() {
        self.txtPhone.addTarget(self, action: #selector(showButtonContinue), for: .editingChanged)
    }
    
    @objc func showButtonContinue() {
        
        if let phone = self.txtPhone.text {
            self.dataHandler.showContinue(with: phone)
        }
    }
}
