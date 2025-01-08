//
//  CodeValidationViewController.swift
//  MyQiwi
//
//  Created by Thyago on 06/11/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class CodeValidationViewController: UIBaseViewController {
    
    @IBOutlet weak var svContainer: UIStackView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btClose: UIButton!
    
    var token = ""
    var didRequest = false
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.didRequest {
            self.requestTokenValidation()
        }
    }
}

extension CodeValidationViewController {

    func requestTokenValidation() {
        self.didRequest = true
        
        Util.showLoading(self)
        TokenRN(delegate: self).validateToken(token: self.token)
    }
    
    @objc func dismissScreen(_ sender: Any?) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension CodeValidationViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if fromClass == TokenRN.self {
                if param == Param.Contact.TOKEN_VALIDATION_RESPONSE {
                    self.dismiss(animated: true, completion: nil)
                    
                    if result {
                        self.dismissPageAfter(after: 0.5)
                        return
                    } else {
                        
                        self.btClose.addTarget(self, action: #selector(self.dismissPage(_:)), for: .touchUpInside)
                    }
                    
                    self.svContainer.isHidden = false
                }
            }
        }
    }
}

extension CodeValidationViewController: SetupUI {
    
    func setupTexts() {
        self.lbTitle.text = "token_fail_title".localized
        self.lbDesc.text = "token_fail_desc".localized
        self.btClose.setTitle("token_try_again".localized, for: .normal)
    }
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        self.svContainer.isHidden = true
        
        Theme.default.redButton(self.btClose)
        
        Util.setTextBarIn(self, title: "token_toolbar_title".localized)
    }
}
