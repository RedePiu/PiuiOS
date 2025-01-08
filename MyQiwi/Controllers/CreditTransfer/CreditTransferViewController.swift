//
//  CreditTransferViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 17/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import ContactsUI

class CreditTransferViewController: UIBaseViewController {

    // MARK: Outlets

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbLabelTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var txtPhone: MaterialField!

    @IBOutlet weak var presentationCard: PresentationCardCell!

    @IBOutlet var btnAgenda: [UIButton]!
    @IBOutlet weak var viewAgenda: UIView!
    @IBOutlet weak var openAgenda: UIButton!
    @IBOutlet weak var viewListContact: UIView!
    @IBOutlet var btnContinue: UIButton!
    @IBOutlet weak var btnVoltar: UIButton!
    
    // MARK: Variables
    var phone: String = ""

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public static var stepListGeneric: Constants.StepListGeneric = .SELECT_OPERATOR

    override func setupViewDidLoad() {
        QiwiOrder.clearFields()
        QiwiOrder.checkoutBody.creditQiwiTransferRequest = CreditQiwiTransferRequest()
        QiwiOrder.setPrvId(prvId: ActionFinder.QIWI_BALANCE_TRANSFER_PRVID)

        self.setupUI()
        self.setupTableView()
        self.setupTexts()
        self.setupTextFields()
    }
}

// MARK: Delegate Table
extension CreditTransferViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

// MARK: SetupUI
extension CreditTransferViewController {
    func setupTableView() {
        //self.tableView.tableFooterView = UIView()
        //self.tableView.layer.masksToBounds = false
    }

    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.greenButton(self.btnContinue)
        Theme.default.blueButton(self.openAgenda)
        Theme.default.orageButton(self.btnVoltar)
    }

    func setupTexts() {
        self.openAgenda.setTitle("credit_qiwi_select_from_cel".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
        self.txtPhone.placeholder = "register_phone".localized
        
        
        Theme.default.textAsListTitle(self.lbTitle)
        
        Util.setTextBarIn(self, title: "Transferir Créditos Qiwi".localized)
    }

    func setupTextFields() {
        self.txtPhone.formatPattern = Constants.FormatPattern.Cell.ddPhone.rawValue
    }

}

// MARK: IBActions
extension CreditTransferViewController {

    @IBAction func openAgenda(sender: UIButton) {
        
        self.chooseContact()
    }

    @IBAction func btnVoltar(sender: UIButton) {
        self.presentedViewController?.dismiss(animated: false, completion: nil)
    }

    @IBAction func clickContinue(sender: UIButton) {
        var phone = self.txtPhone.text ?? ""

        if phone.count < 11 {
            Util.showAlertDefaultOK(self, message: "credit_qiwi_transfer_phone_wrong".localized)
            return
        }

        phone = phone.removeAllOtherCaracters()
        QiwiOrder.checkoutBody.creditQiwiTransferRequest?.phone = phone

        ListGenericViewController.stepListGeneric = .SELECT_VALUE
        performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    @IBAction func backHome(_ sender: Any?) {
        self.view.endEditing(true)
        self.dismiss(animated: false)
        self.navigationController?.presentingViewController?.dismiss(animated: false)
    }

    func chooseContact() {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true)
    }

    func selectStep(step: Constants.StepListGeneric) {
        ListGenericViewController.stepListGeneric = step
        //self.changeLayout()
    }


}


extension CreditTransferViewController: BaseDelegate {

    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?){
            ListGenericViewController.stepListGeneric = .SELECT_VALUE
            self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
}

// MARK: Delegate Contact
extension CreditTransferViewController: CNContactPickerDelegate {

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            let phoneContact = Util.phoneContactFormat(contact)
            QiwiOrder.checkoutBody.creditQiwiTransferRequest?.name = phoneContact.name
            
            if phoneContact.ddd.isEmpty {
                self.phone = phoneContact.number
                self.showDDDInputDialog()
                
                return
            }
            
            self.txtPhone.text = phoneContact.ddd + phoneContact.number
        }
    }
    
    func showDDDInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        
        let desc = "ddd_alert_desc".localized.replacingOccurrences(of: "{number}", with: self.phone)
        let alertController = UIAlertController(title: "ddd_alert_title".localized, message: desc, preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Continuar", style: .default) { (_) in
            
            //getting the input values from user
            var ddd = alertController.textFields?[0].text
            
            if ddd!.count > 2 {
                ddd = String(ddd!.prefix(2))
            }
            
            self.txtPhone.text = ddd! + self.phone
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
        self.present(alertController, animated: true, completion: nil)
    }
}

//extension CreditTransferViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    }



//}
