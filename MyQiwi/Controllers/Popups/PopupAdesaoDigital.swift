//
//  PopupAdesaoDigital.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class PopupAdesaoDigital: UIBaseViewController {
    
    // MARK: Init
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnRemindMe: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    init() {
        super.init(nibName: "PopupAdesaoDigital", bundle: Bundle.main)
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
        Util.showLoading(self)
        UserRN(delegate: self).serviceAdesao(type: AdesaoBody.ADESAO_DIGITAL)
    }
    
    @IBAction func onClickRemind(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        ApplicationRN.resetAppInitCount()
        UserRN.setCanShowAdesaoPopup(canShow: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        UserRN.setCanShowAdesaoPopup(canShow: false)
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: Custom methods

extension PopupAdesaoDigital : BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            
            if param == Param.Contact.USER_ADESAO_RESPONSE {
                Util.showAlertDefaultOK(self, message: "popup_adesao_success_desc".localized, titleOK: "OK", completionOK: {
                    self.dismissPageAfter(after: 0.2)
                })
            }
        }
    }
}

extension PopupAdesaoDigital {
    
}

// MARK: SetupUI

extension PopupAdesaoDigital: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        
        Theme.default.greenButton(self.btnContinue)
        Theme.default.yellowButton(self.btnRemindMe)
        Theme.default.redButton(self.btnCancel)
    }
    
    func setupTexts() {
        self.btnContinue.setTitle("popup_adesao_continue_bt".localized, for: .normal)
        self.btnRemindMe.setTitle("popup_adesao_remind_later_bt".localized, for: .normal)
        self.btnCancel.setTitle("popup_adesao_stop_show_bt".localized, for: .normal)
        
        self.lbTitle.text = "popup_adesao_title".localized
        self.lbDesc.text = "popup_adesao_desc".localized
    }
}

