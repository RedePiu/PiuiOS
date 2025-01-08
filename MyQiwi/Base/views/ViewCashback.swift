//
//  ViewCashback.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 08/05/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class ViewCashback : LoadBaseView {
    
    @IBOutlet weak var svInitialState: UIStackView!
    @IBOutlet weak var imgWinnerBG: UIImageView!
    @IBOutlet weak var imgWinner: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    
    @IBOutlet weak var viewLoading: UIActivityIndicatorView!
    // MARK: Init
    
    var controller: UIViewController?
    var value: Int = 0
    var orderId: Int = 0
    var cashBackApplied = false
    
    override func initCoder() {
        self.loadNib(name: "ViewCashback")
        self.setupView()
    }
    
    @IBAction func onClickShare(_ sender: Any) {
        Util.shareText(sender: controller!, text: "share_text".localized, completion: { activity, completed, items, error in
            
            if completed {
                self.svInitialState.isHidden = true
                self.viewLoading.isHidden = false
                OrderRN(delegate: self).confirmCashback(orderId: self.orderId)
            }
        })
    }
}

extension ViewCashback: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if param == Param.Contact.ORDER_CASHBACK_CONFIRMATON {

                self.lbDesc.isHidden = true
                
                //result = false
                
                if result {
                    self.cashBackApplied = true
                    self.btnShare.isHidden = true
                }
                
                self.svInitialState.isHidden = false
                self.viewLoading.isHidden = true
                
                self.lbTitle.text =  result ? "cash_back_received".localized.replacingOccurrences(of: "{value}", with: Util.formatCoin(value: self.value)) : "cash_back_error".localized
            }
        }
    }
}

extension ViewCashback {
    
    func setupView() {
        
        self.svInitialState.isHidden = false
        self.viewLoading.isHidden = true
        
        self.imgWinner.scale(0)
        
        self.btnShare.setTitle("share".localized)
        
        Theme.default.textAsListTitle(self.lbTitle)
        self.lbDesc.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        
        Theme.default.greenButton(self.btnShare)
    }
    
    func showView() {
        
        self.lbTitle.text = "cash_back_title".localized.replacingOccurrences(of: "{value}", with: Util.formatCoin(value: value))
        self.lbDesc.text = "cash_back_desc".localized
        
        self.imgWinnerBG.fadeIn()
        self.imgWinnerBG.rotate()
        self.imgWinner.scaleIn()
    }
    
    func updateViewStatus(result: Bool) {
        self.svInitialState.isHidden = false
        
        if result {
            self.lbTitle.text = "cash_back_received".localized.replacingOccurrences(of: "{value}", with: Util.formatCoin(value: self.value))
        } else {
            self.lbTitle.text = "cash_back_error".localized
        }
    }
}
