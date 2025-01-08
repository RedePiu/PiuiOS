//
//  PopupPasswordVisibility.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class PopupPasswordVisibility: UIBaseViewController {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbDontAsk: UILabel!
    @IBOutlet weak var btnDontAsk: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    var dontShowAgain: Bool = true
    
    init() {
        super.init(nibName: "PopupPasswordVisibility", bundle: Bundle.main)
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
}

extension PopupPasswordVisibility {
    
    @IBAction func onClickYes(_ sender: Any) {
        PassVisibility.setNeedChangeAll(needChange: true)
        
        if self.dontShowAgain {
            PassVisibility.setCanShowPopup(canShow: false)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickNo(_ sender: Any) {
        PassVisibility.setNeedChangeAll(needChange: false)
        
        if self.dontShowAgain {
            PassVisibility.setCanShowPopup(canShow: false)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickDontAskAgain(_ sender: Any) {
        self.view.endEditing(true)
        
        self.dontShowAgain = !self.dontShowAgain
        
        if !dontShowAgain {
            self.btnDontAsk.setImage(Constants.Image.Button.CHECK_BOX_DISABLED, for: .normal)
            self.btnDontAsk.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            return
        }
        
        self.btnDontAsk.setImage(Constants.Image.Button.CHECK_BOX_ENABLE, for: .normal)
        self.btnDontAsk.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorAccent)
    }
}

// MARK: SetupUI

extension PopupPasswordVisibility: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        
        Theme.default.greenButton(self.btnYes)
        Theme.default.redButton(self.btnNo)
        
        self.btnDontAsk.imageView?.image = self.btnDontAsk.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.btnDontAsk.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorAccent)
        
        self.dontShowAgain = true
        self.btnDontAsk.setImage(Constants.Image.Button.CHECK_BOX_ENABLE, for: .normal)
        self.btnDontAsk.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorAccent)
        
        self.lbDontAsk.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.lbDontAsk.font = FontCustom.helveticaRegular.font(15)
    }
    
    func setupTexts() {
        self.btnYes.setTitle("password_visibility_yes".localized, for: .normal)
        self.btnNo.setTitle("password_visibility_no".localized, for: .normal)
        
        self.lbTitle.text = "password_visibility_title".localized
        self.lbDesc.text = "password_visibility_desc".localized
        self.lbDontAsk.text = "password_visibility_check".localized
    }
}
