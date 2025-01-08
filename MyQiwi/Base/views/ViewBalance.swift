//
//  ViewBalance.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewBalance: LoadBaseView {

    // MARK: Outlets

    @IBOutlet weak var lbLabelAccount: UILabel!
    @IBOutlet weak var lbAccountValue: UILabel!
    @IBOutlet weak var lbLabelRefresh: UILabel!
    @IBOutlet weak var imgRefresh: UIImageView!
    @IBOutlet weak var btnRecharge: UIButton!
    @IBOutlet weak var btnTransfer: UIButton!
    @IBOutlet weak var btnHistorico: UIButton!

    // MARK: Variables

    lazy var mUserRN = UserRN(delegate: self)
    var delegate: BaseDelegate?
    var autoupdate = true
    var mCanShow = true

    // MARK: Init

    override func initCoder() {
        self.loadNib(name: "ViewBalance")
        self.setupViewRefresh()
    }

}


// MARK: Setup

extension ViewBalance {

    func setupViewRefresh() {

        Theme.BalanceQiwi.textAsAccount(self.lbLabelAccount)
        Theme.BalanceQiwi.textAsValue(self.lbAccountValue)
        Theme.BalanceQiwi.textAsRefresh(self.lbLabelRefresh)
        Theme.BalanceQiwi.setColorRefresh(self.imgRefresh)
        Theme.default.orageButton(self.btnRecharge)
        Theme.default.blueButton(self.btnTransfer)
        Theme.default.blueButton(self.btnHistorico)

        self.lbLabelAccount.text = "balance_title".localized
        self.lbLabelRefresh.text = "balance_refresh".localized
        self.lbAccountValue.text = "balance_updating".localized
        self.btnRecharge.setTitle("balance_recharge".localized, for: .normal)
        self.btnTransfer.setTitle("balance_transfer".localized, for: .normal)
        self.btnHistorico.setTitle("balance_historico".localized, for: .normal)

        self.lbLabelAccount.font = UIFont(name:"balance_title" , size: 20)
        self.lbAccountValue.font = UIFont(name:"balance_updating" , size: 24)
        
        self.lbLabelRefresh.superview?.isHidden = true
        self.btnTransfer.isHidden = true
        
        if ApplicationRN.isQiwiBrasil() {
            self.btnHistorico.isHidden = true
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleRefresh))
        self.lbLabelRefresh.superview?.addGestureRecognizer(tapGesture)
    }

    func setBalance(balance: Int) {
        self.lbAccountValue.text = Util.formatCoin(value: balance)
//
//        self.btnTransfer.isHidden = false
//        
        if !self.mCanShow {
            //self.btnTransfer.isHidden = balance <= 0
            self.btnTransfer.isHidden = true
            self.btnHistorico.isHidden = true
        }
        else if ApplicationRN.isQiwiBrasil() {
            self.btnTransfer.isHidden = false
            self.btnHistorico.isHidden = true
        }
        else {
            self.btnTransfer.isHidden = true
            self.btnHistorico.isHidden = false
        }
    }

    func updateBalance() {
        self.btnTransfer.isHidden = true
        self.lbAccountValue.text = "balance_updating".localized
        self.mUserRN.getQiwiBalance()
    }

    func hideButtons() {
        self.mCanShow = false
        self.btnRecharge.isHidden = true
        self.btnTransfer.isHidden = true
    }

    func hideTransferButton() {
        self.mCanShow = false
        self.btnTransfer.isHidden = true
    }

    @objc func toggleRefresh() {
        self.lbLabelRefresh.superview?.isHidden = true
        updateBalance()
    }
}

extension ViewBalance : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if fromClass == UserRN.self {
                if param == Param.Contact.QIWI_BALANCE_RESPONSE {
                    self.lbLabelRefresh.superview?.isHidden = result

                    //Avisa para a view controller que terminou de atualizar o saldo
                    if self.delegate != nil {
                        self.delegate?.onReceiveData(fromClass: ViewBalance.self, param: param, result: result, object: nil)
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
