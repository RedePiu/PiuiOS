//
//  ViewPIXInfo.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 17/02/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class ViewPIXInfo : LoadBaseView {
    
    // MARK: Init
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbKey: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbCopy: UILabel!
    @IBOutlet weak var lbShare: UILabel!
    @IBOutlet weak var lbTimeLimit: UILabel!
    @IBOutlet weak var lbOrderWIllBeUpdated: UILabel!
    
    var sender: UIBaseViewController?
    var delegate: BaseDelegate?
    var savedAccounts = [BankRequest]()
    
    override func initCoder() {
        self.loadNib(name: "ViewPIXInfo")
        self.setupView()
    }
}

extension ViewPIXInfo {
    
    @IBAction func onClickCopy(_ sender: Any) {
        UIPasteboard.general.string = self.lbKey.text
                
        let title = "Código Copiado"
        let message = "Seu código de barras foi copiado pra área de transferência."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {
            action in
            
        }))
        
        self.sender?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onClickShare(_ sender: Any) {
        let codeToShare = [self.lbKey.text]
        let activityViewController = UIActivityViewController(activityItems: codeToShare, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.copyToPasteboard ]
        self.sender?.present(activityViewController, animated: true, completion: nil)
    }
}

extension ViewPIXInfo {
 
    func setValue(value: Int) {
        self.lbDesc.text = "pix_info_value".localized.replacingOccurrences(of: "{VALUE}", with: Util.formatCoin(value: value))
    }
}

extension ViewPIXInfo {
    
    func setupView() {
        
        Theme.TransportInstructions.textAsDesc(self.lbTitle)
        Theme.TransportInstructions.textAsTitle(self.lbDesc)
        //Theme.TransportInstructions.textAsDesc(self.lbKey)
        //Theme.TransportInstructions.textAsDesc(self.lbDesc)
        Theme.TransportInstructions.textAsDesc(self.lbCopy)
        Theme.TransportInstructions.textAsDesc(self.lbShare)
        Theme.TransportInstructions.textAsDesc(self.lbOrderWIllBeUpdated)
        
        self.lbTitle.text = "pix_info_title".localized
        self.lbTimeLimit.text = "pix_info_48h".localized
        self.lbOrderWIllBeUpdated.text = "pix_info_order_will_be_updated".localized
        
        //REMOVER
        //self.lbKey.text = Util.formatText(text: "12865530000181", format: "##.###.###/####-##")
        
        let bank = PaymentRN(delegate: nil).getBank(bankId: ActionFinder.Bank.PIX)
        if bank.account.isEmpty {
            self.lbKey.text = Util.formatText(text: "12865530000181", format: "##.###.###/####-##")
            return
        }

        self.lbKey.text = Util.formatText(text: bank.account, format: "##.###.###/####-##")

    }
}
