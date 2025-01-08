//
//  PopupDataPrivacyViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 21/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit
import WebKit

class PopupDataPrivacyViewController: UIBaseViewController {

    // MARK: Outlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    
    // MARK: Variables
    
    // MARK: Init
    
    init() {
        super.init(nibName: "PopupDataPrivacyViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Ciclo de Vida
    
    override func setupViewDidLoad() {
    
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        
        
    }
}

// MARK: IBActions
extension PopupDataPrivacyViewController {
    
    @IBAction func onClickAccept(sender: UIButton) {
        ApplicationRN.setDataPrivacyConfirmed()
        self.dismiss(animated: false)
    }
}

// MARK: SetupUI
extension PopupDataPrivacyViewController: SetupUI {
    
    func setupUI() {
    }
    
    func setupTexts() {
        self.lbTitle.text = "data_privacy_title".localized
        self.lbDesc.text = "data_privacy_desc".localized
        self.btnAccept.setTitle("ok_got_it".localized, for: .normal)
    }
}
