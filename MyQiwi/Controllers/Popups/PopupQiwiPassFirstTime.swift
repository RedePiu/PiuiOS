//
//  PopupQiwiPassFirstTime.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 26/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class PopupQiwiPassFirstTime: UIBaseViewController {
    
    // MARK: Init
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    init() {
        super.init(nibName: "PopupQiwiPassFirstTime", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        ForgotPasswordViewController.isChangeAccountPassword = false
        ForgotPasswordViewController.needToCloseWhenBack = true
        Util.showStoryboard(self, name: "ForgotPassword")
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Custom methods

extension PopupQiwiPassFirstTime {
   
}

// MARK: SetupUI

extension PopupQiwiPassFirstTime: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        
        Theme.default.greenButton(self.btnContinue)
        Theme.default.redButton(self.btnCancel)
    }
    
    func setupTexts() {
        self.btnContinue.setTitle("create_qiwi_pass_continue".localized, for: .normal)
        self.btnCancel.setTitle("create_qiwi_pass_cancel".localized, for: .normal)
        
        self.lbTitle.text = "create_qiwi_pass_title".localized
        self.lbDesc.text = "create_qiwi_pass_desc".localized
    }
}
