//
//  PaymentLimitsViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class PaymentLimitsViewController: UIBaseViewController {

    // MARK: Outlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbTotalValue: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lbTax: UILabel!
    @IBOutlet weak var svTax: UIStackView!
    @IBOutlet weak var divTax: UIView!
    @IBOutlet weak var lbCurrentValue: UILabel!
    
    // MARK: Variables
    static var paymentType = 0
    var popupDelegate : IPopupStatus?
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.popupDelegate?.popupClosed()
        self.dismiss(animated: true, completion: nil)
    }
}

extension PaymentLimitsViewController {
    
    func getValueWithTax() {
        let checkoutRN = CheckoutRN(delegate: nil)
        let tax = checkoutRN.checkTaxesForPaymentMethod(prvId: QiwiOrder.getPrvID(), paymentType: PaymentLimitsViewController.paymentType)
        let valueWithTax = Util.formatCoin(value: checkoutRN.getValueWithTax(tax: tax, value: QiwiOrder.getValue()))
        let paymentLimit = PaymentRN(delegate: nil).getPaymentLimit(prvid: QiwiOrder.getPrvID(), paymentMethod: PaymentLimitsViewController.paymentType)
        let maxValue = Util.formatCoin(value: paymentLimit.maxValue)
        
        self.lbDesc.text = "payment_limit_desc".localized
            .replacingOccurrences(of: "{value}", with: valueWithTax)
            .replacingOccurrences(of: "{max_value}", with: maxValue)
        self.lbTax.text = checkoutRN.getValueWithTaxText(tax: tax, value: QiwiOrder.getValue())
        self.lbCurrentValue.text = Util.formatCoin(value: QiwiOrder.getValue())
        self.lbTotalValue.text = valueWithTax
        
        //Se nao houver taxa, esconde
        self.lbTax.isHidden = tax.prvId == 0
        self.divTax.isHidden = tax.prvId == 0
        
        Theme.default.textAsMessage(self.lbCurrentValue)
        Theme.default.textAsMessage(self.lbTax)
        Theme.default.textAsMessage(self.lbTotalValue)
        self.lbTotalValue.textColor = Theme.default.red
    }
}

// MARK: SetupUI

extension PaymentLimitsViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.textAsDefault(self.lbCurrentValue)
        Theme.default.textAsDefault(self.lbTotalValue)
        
        Theme.default.orageButton(self.btnBack)
    }
    
    func setupTexts() {
        
        var paymentTypeText = ""
        
        if PaymentLimitsViewController.paymentType == ActionFinder.Payments.CREDIT_CARD {
            paymentTypeText = "payment_limit_type_credit_card".localized
        }
        else if PaymentLimitsViewController.paymentType == ActionFinder.Payments.BANK_TRANSFER {
            paymentTypeText = "payment_limit_type_bank_transfer".localized
        }
        else if PaymentLimitsViewController.paymentType == ActionFinder.Payments.QIWI_BALANCE {
            paymentTypeText = "payment_limit_type_qiwi_balance".localized
        }
        
        self.lbTitle.text = "payment_limit_title".localized.replacingOccurrences(of: "{payment_type}", with: paymentTypeText)
        self.getValueWithTax()
        
//        self.lbCreditMin.text = strings[0]
//        self.lbCreditMin.textColor = strings[0].elementsEqual("payment_limit_unlimited".localized) ? Theme.default.red : Theme.default.blue
    }
}

extension PaymentLimitsViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
    }
}
