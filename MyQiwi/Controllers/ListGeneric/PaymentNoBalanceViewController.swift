//
//  PaymentNoBalanceViewController.swift
//  MyQiwi
//
//  Created by Ailton on 02/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class PaymentNoBalanceViewController : UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewWarning: ViewWarning!
    @IBOutlet weak var viewBalance: ViewBalance!
    @IBOutlet weak var btnBack: UIButton!
    
    // MARK: Variables
    var balance: Int = 0
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        self.viewBalance.btnRecharge.addTarget(self, action: #selector(onClickRecharge), for: .touchUpInside)
    }
    
    override func setupViewWillAppear() {
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.popPage()
    }
    
    @objc func onClickRecharge() {
        QiwiOrder.startQiwiChargeOrder()
        ListGenericViewController.stepListGeneric = .SELECT_VALUE
        
        performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
}

extension PaymentNoBalanceViewController {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.textAsListTitle(self.lbTitle)

        self.viewBalance.hideTransferButton()
        self.viewWarning.backgroundColor = Theme.default.red
    }
    
    func setupTexts() {
        self.btnBack.setTitle("back".localized, for: .normal)
        self.lbTitle.text = "payments_credit_qiwi_balance".localized
        self.viewWarning.lbDesc.text = "checkout_no_balance".localized
        
        Util.setTextBarIn(self, title: QiwiOrder.productName)
        
        self.viewBalance.setBalance(balance: self.balance)
    }
}
