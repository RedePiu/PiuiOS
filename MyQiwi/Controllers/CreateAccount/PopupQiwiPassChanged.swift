//
//  PopupQiwiPassChanged.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 22/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class PopupQiwiPassChanged: UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    // MARK: Ciclo de vida
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.performSegue(withIdentifier: Constants.Segues.FORM_WELCOME, sender: nil)
        }
    }
}
// MARK: SetupUI
extension PopupQiwiPassChanged: SetupUI {
    
    func setupUI() {
        
        Theme.default.greenButton(self.btnContinue)

//        Theme.default.textAsListTitle(self.lblConfirmation)
//        Theme.default.textAsListTitle(self.lblMessage)
    }
    
    func setupTexts() {
        self.lbTitle.text = "register_qiwi_pass_changed_title".localized
        self.lbDesc.text = "register_qiwi_pass_changed_desc".localized
        
        Util.setTextBarIn(self, title: "")
    }
}
