//
//  BankComingSoonViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 30/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

protocol DismisModalDelegate {
    
    func modalDismiss()
}

class BankComingSoonViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    
    // MARK: Variables
    
    var delegateModal: DismisModalDelegate?

    // MARK: Init
    
    init() {
        super.init(nibName: "BankComingSoonViewController", bundle: Bundle.main)
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
        Util.setTextBarIn(self, title: "content_soon_toolbar_title".localized)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions
extension BankComingSoonViewController {
    
    @IBAction func closeModal(sender: UIButton) {
        self.dismiss(animated: false)
        self.delegateModal?.modalDismiss()
    }
}

// MARK: SetupUI
extension BankComingSoonViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        
        self.lbTitle.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.lbMessage.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        
        self.lbTitle.setupTitleBold()
        self.lbMessage.setupMessageMedium()
    }
    
    func setupTexts() {
        
//        self.lbTitle.text = "content_soon_title".localized
//        self.lbMessage.text = "content_soon_desc".localized
        self.btnBack.setTitle("back".localized, for: .normal)
    }
}
