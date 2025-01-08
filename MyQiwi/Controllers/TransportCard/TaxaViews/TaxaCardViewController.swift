//
//  TaxaCardViewController.swift
//  MyQiwi
//
//  Created by Daniel Catini on 03/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import UIKit

class TaxaCardViewController: UIBaseViewController {
    
    // MARK: - Properties
    var isEditingTableView = false
    lazy var taxaCardRN = TaxaCardRN(delegate: self)

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTexts()
        taxaCardRN.DeleteAll()
    }
    
    @IBAction func closeClick(_ sender: UIBarButtonItem) {
        self.dismissPage(sender)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.popPage(sender)
    }

    @IBAction func btnEuClick(_ sender: Any) {
        Constants.cpfTaxa = "eu"
        self.performSegue(withIdentifier: Constants.Segues.TAXA_CPF, sender: nil)
    }
    @IBAction func btnOutraClick(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.Segues.TAXA_CPF, sender: nil)
    }
}

extension TaxaCardViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {}
}

// MARK: SetupUI
extension TaxaCardViewController: SetupUI {

    func setupUI() {
        Theme.default.backgroundCard(self)
    }

    func setupTexts() {
        Util.setTextBarIn(self, title: QiwiOrder.selectedMenu.desc)
    }

    func setupHeightTable() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
