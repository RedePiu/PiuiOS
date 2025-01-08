//
//  ViewStatusOrder.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewStatusOrder: LoadBaseView {

    // MARK: Outlets
    
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbInfo: UILabel!
    @IBOutlet weak var btnSee: UIButton!
    @IBOutlet weak var imgIconType: UIImageView!
    @IBOutlet weak var btReason: UIButton!
    @IBOutlet weak var viewReceipt: ViewReceipt!
    @IBOutlet weak var btShare: UIButton!
    
    @IBOutlet weak var viewResendReceipt: UIStackView!
    @IBOutlet weak var lbReceiptSentTo: UILabel!
    @IBOutlet weak var lbReceiptTime: UILabel!
    @IBOutlet weak var btnResendReceipt: UIButton!
    
    var timer: Timer?
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewStatusOrder")
        self.setupViewStatusOrder()
    }
}

extension ViewStatusOrder {
    
    fileprivate func setupViewStatusOrder() {
        
        Theme.default.orageButton(self.btnSee)
        Theme.default.orageButton(self.btShare)
        Theme.default.orageButton(self.btnResendReceipt)
        
        self.lbReceiptSentTo.isHidden = true
        self.lbReceiptTime.isHidden = true
        
        self.btnSee.setTitle("ver pedido".localized, for: .normal)
        self.btReason.setTitle("checkout_button_go_to_orders".localized, for: .normal)
        self.btShare.setTitle("order_share_button".localized, for: .normal)
        self.btnResendReceipt.setTitle("order_resend_button".localized, for: .normal)
    }
    
    func showResendOptions() {
        self.viewResendReceipt.isHidden = false
    }
    
    func hideResendOptions() {
        self.viewResendReceipt.isHidden = true
    }
    
    func showSentMessage(phone: String) {
        self.lbReceiptSentTo.isHidden = false
        self.lbReceiptSentTo.text = "order_sent_to".localized.replacingOccurrences(of: "{phone}", with: phone)
    }
    
    func startResendTimer() {
        
        if self.timer != nil {
            self.timer?.invalidate()
        }
        
        self.btnResendReceipt.isEnabled = false
        
        var count = 60
        let textTimer = "order_timer".localized
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            
            if count == 0 {
                self.lbReceiptSentTo.isHidden = true
                self.lbReceiptTime.isHidden = true
                self.timer?.invalidate()
                self.btnResendReceipt.isEnabled = true
                return
            }

            self.lbReceiptTime.isHidden = false
            self.lbReceiptTime.text = textTimer.replacingOccurrences(of: "{sec}", with: String(count))
            count = count - 1
        })
    }
}
