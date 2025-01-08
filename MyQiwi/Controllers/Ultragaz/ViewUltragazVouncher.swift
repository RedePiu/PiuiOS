//
//  ViewUltragazVouncher.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 18/05/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class ViewUltragazVouncher: LoadBaseView {
    
    // MARK : VIEWS
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbAskTitle: UILabel!
    @IBOutlet weak var lbAskDesc: UILabel!
    @IBOutlet weak var lbWhatsapp: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var lbCopied: UILabel!
    
    // MARK : VARIABLES
    var code = "XXXX"
    
    override func initCoder() {
        self.loadNib(name: "ViewUltragazVouncher")
        self.setupView()
        self.setupText()
    }
}

extension ViewUltragazVouncher {
    
    @IBAction func onClickCopy(_ sender: Any) {
        self.btnCopy.fadeOut()
        self.lbCopied.fadeIn()
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = self.code
        
        self.doActionAfter(after: 4, completion: {
            self.btnCopy.fadeIn()
            self.lbCopied.fadeOut()
        })
    }
    
    @IBAction func onClickWhatsapp(_ sender: Any) {
        self.sendCodeWhatsApp()
    }
    
    @IBAction func onClickCall(_ sender: Any) {
        self.openPhoneCall()
    }
}

extension ViewUltragazVouncher {
    
    func setupView() {
        let titleColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.lbTitle.textColor = titleColor
        self.lbAskTitle.textColor = titleColor
        self.lbCopied.alpha = 0
        
        let color = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        self.lbDesc.textColor = color
        self.lbAskDesc.textColor = color
        self.lbWhatsapp.textColor = color
        self.lbNumber.textColor = color
    }
    
    func setupText() {
        self.lbTitle.text = "ultragaz_purchase_title".localized
        self.lbDesc.text = "ultragaz_purchase_desc".localized
        self.lbAskTitle.text = "ultragaz_purchase_ask".localized
        self.lbAskDesc.text = "ultragaz_purchase_ask_desk".localized
        self.lbWhatsapp.text = "ultragaz_purchase_whats".localized
        self.lbNumber.text = "ultragaz_purchase_phone_number".localized
        
        self.btnCopy.setTitle("ultragaz_purchase_copy".localized.uppercased(), for: .normal)
    }
}

extension ViewUltragazVouncher {
    
    func setCode(code: String) {
        self.code = code
        self.lbCode.text = code
    }
}

extension ViewUltragazVouncher {
    
    func sendCodeWhatsApp() {
        let msg = "ultragaz_whatsapp_msg".localized.replacingOccurrences(of: "{number}", with: self.code)
        
        let urlWhats = "whatsapp://send?phone=558007010123&text=\(msg)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    UIApplication.shared.openURL(whatsappURL)
                } else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    func openPhoneCall() {
        var phone = "ultragaz_purchase_phone_number".localized
        guard let number = URL(string: "tel://"+phone.removeSpace()) else { return }
        UIApplication.shared.open(number)
    }
}
