//
//  ViewBalancePrePago.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ViewBalancePrePago: LoadBaseView {

    @IBOutlet weak var lbLabelAccount: UILabel!
    @IBOutlet weak var lbAccountValue: UILabel!
    @IBOutlet weak var imgRefresh: UIImageView!
    @IBOutlet weak var lbLabelRefresh: UILabel!
    @IBOutlet weak var btnRecharge: UIButton!
    
    @IBOutlet weak var imgMoneyPrePago: UIImageView!
    @IBOutlet weak var imgMoneyQiwi: UIImageView!
    @IBOutlet weak var lbPrePago: UILabel!
    @IBOutlet weak var lbContaQiwi: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    
    // MARK: Variables

    lazy var mUserRN = UserRN(delegate: self)
    var delegate: BaseDelegate?
    var autoupdate = true
    var mCanShow = true

    // MARK: Init

    override func initCoder() {
        self.loadNib(name: "ViewBalancePrePago")
        
        self.setupViewRefresh()
    }
}

// MARK: Setup

extension ViewBalancePrePago {

    func setupViewRefresh() {

        Theme.BalanceQiwi.textAsAccount(self.lbLabelAccount)
        Theme.BalanceQiwi.textAsValue(self.lbAccountValue)
        Theme.BalanceQiwi.textAsRefresh(self.lbLabelRefresh)
        Theme.BalanceQiwi.setColorRefresh(self.imgRefresh)
        Theme.default.greenButton(self.btnRecharge)

        self.lbLabelAccount.text = "balance_prepago_title".localized
        self.lbLabelRefresh.text = "balance_refresh".localized
        self.lbAccountValue.text = "balance_updating".localized
        self.btnRecharge.setTitle("balance_prepago_transfer".localized, for: .normal)
        
        self.imgMoneyPrePago.image = UIImage(named: "ic_money_bag")?.withRenderingMode(.alwaysTemplate)
        self.imgMoneyPrePago.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        
        self.imgMoneyQiwi.image = UIImage(named: "ic_money_bag")?.withRenderingMode(.alwaysTemplate)
        self.imgMoneyQiwi.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        
        self.imgArrow.image = UIImage(named: "ic_left_arrow")?.withRenderingMode(.alwaysTemplate)
        self.imgArrow.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)

        self.lbLabelAccount.font = UIFont(name:"balance_title" , size: 20)
        self.lbAccountValue.font = UIFont(name:"balance_updating" , size: 24)
        
        self.lbLabelRefresh.superview?.isHidden = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleRefresh))
        self.lbLabelRefresh.superview?.addGestureRecognizer(tapGesture)
    }

    func setBalance(balance: Int) {
        self.lbAccountValue.text = Util.formatCoin(value: balance)
    }

    func updateBalance() {
        self.lbAccountValue.text = "balance_updating".localized
        self.mUserRN.getPrePagoBalance()
    }

    func hideButtons() {
        self.mCanShow = false
        self.btnRecharge.isHidden = true
    }

    @objc func toggleRefresh() {
        self.lbLabelRefresh.superview?.isHidden = true
        updateBalance()
    }
}

extension ViewBalancePrePago : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if fromClass == UserRN.self {
                if param == Param.Contact.PRE_PAGO_BALANCE_RESPONSE {
                    self.lbLabelRefresh.superview?.isHidden = result

                    //Avisa para a view controller que terminou de atualizar o saldo
                    if self.delegate != nil {
                        self.delegate?.onReceiveData(fromClass: ViewBalancePrePago.self, param: param, result: result, object: nil)
                    }

                    if !result {

                        self.lbAccountValue.text = "balance_no_available".localized
                        return
                    }

                    let balance = object as! Int
                    QiwiOrder.userBalance = balance
                    self.setBalance(balance: balance)
                }
            }
        }
    }
}
