//
//  TransportQuoteViewController.swift
//  MyQiwi
//
//  Created by Ailton on 08/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class TransportQuoteViewController: UIBaseViewController {
    
    // MARK: Outlet
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbMaxQuote: UILabel!
    @IBOutlet weak var btnLess: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var viewWarning: ViewWarning!
    @IBOutlet weak var btnContinue: UIButton!
    
    // MARK: Variaveis
    var mType: String?
    var minAmount: Int = 1
    var maxAmount: Int = 1
    var amount: Int = 1
    var price: Double = 1
    
    var transportQuoteDelegate: TransportQuoteDelegate?
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.defineValues()
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.defineValues()
    }
    
    func defineValues() {
        if QiwiOrder.isTransportRecharge() {
            self.maxAmount = Int((QiwiOrder.transportTypeSelected?.maxAmount)!)
            self.price = QiwiOrder.transportTypeSelected!.unitValue
        }
        else if QiwiOrder.isTransportProdataRecharge() {
            
            var min = Int((QiwiOrder.transportProdataProduct?.minValue)!/(QiwiOrder.transportProdataProduct?.unitValue)!)
            if min == 0 {
                min = 1
            }
            
            self.minAmount = min
            self.maxAmount = Int((QiwiOrder.transportProdataProduct?.maxValue)!/(QiwiOrder.transportProdataProduct?.unitValue)!)
            self.price = Double(QiwiOrder.transportProdataProduct!.unitValue/100)
        }
        
        self.amount = self.minAmount
        self.lbAmount.text = String(self.amount)
        self.updatePrice()
    }
    
    @IBAction func onClickLess(_ sender: Any) {
        self.decrementAmount()
    }
    
    @IBAction func onClickMore(_ sender: Any) {
        self.incrementAmount()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        ListGenericViewController.stepListGeneric = .SELECT_TRANSPORT_WHERE_WILL_USE
        self.popPage()
    }
    
    @IBAction func onClickContinue(_ sender: Any) {

        // Novos valores
        let value = Util.doubleToInt(self.price)
        QiwiOrder.setTransitionAndValue(value: value * self.amount)
        
        if QiwiOrder.isTransportRecharge() {
            QiwiOrder.checkoutBody.requestTransport?.amount = self.amount
        }

        // voltar para a lista generic
        self.popPage()
        
        // passa informação para carregar lista de pagamentos
        self.transportQuoteDelegate?.showList(step: .SELECT_PAYMENT)
    }
}

extension TransportQuoteViewController {
    
    func incrementAmount() {
        if self.amount < self.maxAmount {

            self.amount = self.amount + 1
            self.lbAmount.text = String(self.amount)
            
            self.updatePrice()
        }
    }
    
    func decrementAmount() {
        
        if self.amount > self.minAmount {
            self.amount = self.amount - 1
            self.lbAmount.text = String(self.amount)
            
            self.updatePrice()
        }
    }
    
    func updatePrice() {
        
        self.lbPrice.text = Util.formatCoin(value: (self.price * Double(self.amount)))
    }
}

extension TransportQuoteViewController {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
    
        self.setupViewWarning()
        self.setupAmout()
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "transport_toolbar_title".localized)
        
        self.lbTitle.text = "transport_select_amount".localized
            .replacingOccurrences(of: "{type}", with: self.mType!)
        self.lbPrice.text = Util.formatCoin(value: self.price)
        self.lbMaxQuote.text = "transport_quota".localized
            .replacingOccurrences(of: "{value}", with: String(self.maxAmount))
        
        self.lbAmount.text = String(self.amount)
        
        if QiwiOrder.isTransportRecharge() {
            self.viewWarning.isHidden = false
            let id = QiwiOrder.transportTypeSelected?.code
            if ActionFinder.isBilheteUnicoDiario(id: id!) || ActionFinder.isBilheteUnicoEstudanteDiario(id: id!) {
                self.viewWarning.lbDesc.text = "transport_daily_amount_desc".localized
            } else {
                self.viewWarning.lbDesc.text = "transport_montly_amount_desc".localized
            }
        }
        else {
            self.viewWarning.isHidden = true
        }
    }
    
    func setupViewWarning() {
        
        self.viewWarning.backgroundColor = Theme.default.orange
        self.viewWarning.imgIcon.image = UIImage(named: "ic_warning")?.withRenderingMode(.alwaysTemplate)
        self.viewWarning.imgIcon.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    func setupAmout() {
        
        self.lbAmount.layer.cornerRadius = 15
        self.lbAmount.layer.borderColor = UIColor(hexString: Constants.Colors.Hex.colorGrey4).cgColor
        self.lbAmount.layer.borderWidth = 1
    }
}
