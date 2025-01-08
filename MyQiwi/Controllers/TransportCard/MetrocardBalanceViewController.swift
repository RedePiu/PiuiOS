//
//  MetrocardBalanceViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 31/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class MetrocardBalanceViewController : UIBaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbCardName: UILabel!
    @IBOutlet weak var lbCardNumber: UILabel!
    @IBOutlet weak var lbNoContent: UILabel!
    @IBOutlet weak var lbCPF: UILabel!
    
    @IBOutlet weak var viewNoContent: UIView!
    @IBOutlet weak var ivRefresh: UIImageView!
    @IBOutlet weak var viewBalance: UIStackView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCharge: UIButton!
    
    // MARK : VARIABLES
    lazy var metrocardRN = MetrocardRN(delegate: self)
    var balance = MetrocardBalance()
    var transportCard = TransportCard()
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        
        self.requestBalance()
    }
    
    @IBAction func onClickCharge(_ sender: Any) {
        ListGenericViewController.stepListGeneric = .SELECT_VALUE
        self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
}

extension MetrocardBalanceViewController {
    
    func requestBalance() {
        Util.showLoading(self)
        self.metrocardRN.getBalances(cpf: QiwiOrder.checkoutBody.requestMetrocard!.cpf, card: QiwiOrder.checkoutBody.requestMetrocard!.card)
    }
    
    func fillBalance(balance: MetrocardBalance) {
        self.balance = balance
        
        if balance.cpf.isEmpty {
            self.lbNoContent.text = "metrocard_balance_no_data".localized
            self.viewNoContent.isHidden = false
            self.viewBalance.isHidden = true
            self.ivRefresh.isHidden = true
            self.btnCharge.isHidden = true
            return
        }
        
        self.lbValue.text = Util.formatCoin(value: balance.balance)
        self.lbDate.text = "metrocard_balance_date".localized.replacingOccurrences(of: "{date}", with: DateFormatterQiwi.formatDate(balance.date, currentFormat: DateFormatterQiwi.defaultDateWithoutTPattern, toFormat: DateFormatterQiwi.dateAndHour))
        
        self.viewNoContent.isHidden = true
        self.viewBalance.isHidden = false
        self.btnCharge.isHidden = false
    }
}

extension MetrocardBalanceViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            
            if param == Param.Contact.METROCARD_BALANCE_RESPONSE {
                self.dismissPage(true)
                
                if !result {
                    self.lbNoContent.text = "metrocard_balance_error".localized
                    self.viewNoContent.isHidden = false
                    self.btnCharge.isHidden = true
                    return
                }
                
                self.fillBalance(balance: object as! MetrocardBalance)
            }
        }
    }
}

extension MetrocardBalanceViewController : SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnCharge)
        Theme.default.textAsListTitle(self.lbCardName)
        Theme.default.textAsListTitle(self.lbValue)
        Theme.default.textAsMessage(self.lbCardNumber)
        Theme.default.textAsMessage(self.lbCPF)
        Theme.default.textAsMessage(self.lbDate)

        self.ivRefresh.image = UIImage(named: "ic_refresh")?.withRenderingMode(.alwaysTemplate)
        self.ivRefresh.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey4)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "transport_balance_title_nav".localized)
        
        self.lbCardName.text = !self.transportCard.name.isEmpty ? self.transportCard.name : "Cartão Metrocard"
        self.lbCardNumber.text = self.transportCard.number
        self.lbCPF.text = self.transportCard.cpf

        self.lbNoContent.text = "metrocard_balance_error".localized
    }
}
