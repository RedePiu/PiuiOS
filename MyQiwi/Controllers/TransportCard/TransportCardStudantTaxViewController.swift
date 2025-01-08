//
//  TransportCardStudantTaxViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 04/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class TransportCardStudantTaxViewController: UIBaseViewController {
    
    
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var btContinue: UIButton!
    @IBOutlet weak var btBack: UIButton!
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupTableView()
    }
    
    override func setupViewWillAppear() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        
        ListGenericViewController.stepListGeneric = .SELECT_TRANSPORT_RECHARGE_TYPE
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Setup UI
extension TransportCardStudantTaxViewController: SetupUI {
    func setupTableView(){
        
    }
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btBack)
        Theme.default.blueButton(self.btContinue)
    }
    
    func setupTexts() {
        self.lbTitle.text = "transport_studant_tax_title".localized
        Util.setTextBarIn(self, title: "transport_toolbar_title".localized)
        
        self.lbValue.text = Util.formatCoin(value: QiwiOrder.checkoutBody.transition?.value ?? 0)
    }
}
