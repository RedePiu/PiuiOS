//
//  StudentPickupCardAddressView.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 04/03/22.
//  Copyright © 2022 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class StudentPickupCardAddressView : LoadBaseView {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    var viewController: UIBaseViewController?
    
    override func initCoder() {
        self.loadNib(name: "StudentPickupCardAddressView")
        self.setupView()
    }
}

extension StudentPickupCardAddressView {
    
    @IBAction func onClickCopy(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = "Parque Dr. Barbosa de Oliveira, s/n - Boxe 70 - Taubaté, SP - CEP 12020-190"
        
        Util.showAlertDefaultOK(self.viewController!, message: "Copiado para a área de transferência.")
    }
    
    @IBAction func onClickCall(_ sender: Any) {
        guard let number = URL(string: "tel://1236215300") else { return }
        UIApplication.shared.open(number)
    }
}

extension StudentPickupCardAddressView {
    
    func setupView() {
        //Theme.default.textAsListTitle(lbTitle)
        lbTitle.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        lbDesc.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        lbAddress.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
    
    }
}
