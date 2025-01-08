//
//  DividaPIXViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 23/02/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class DividaPIXViewController : UIBaseViewController {
    
    @IBOutlet weak var viewPIX: ViewPIX!
    @IBOutlet weak var viewPIXInfo: ViewPIXInfo!
    @IBOutlet weak var viewStatus: UICardView!
    @IBOutlet weak var viewContinue: ViewContinue!
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    
    var selectedDivida = Divida()
    var canExit = false
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        
        self.viewPIXInfo.isHidden = true
        self.viewStatus.isHidden = true
        self.viewPIX.isHidden = false
        self.viewPIX.delegate = self
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(onClickContinue), for: .touchUpInside)
    }
}


extension DividaPIXViewController {
    
    @IBAction func onClickBackNavigationBar(_ sender: Any) {
        if !canExit {
            self.view.endEditing(true)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func onClickFinishSuccess(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickFinishFailed(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickBack(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func onClickContinue(sender: UIButton) {
        let pix = self.viewPIX.getInputRequest()
                    
        if pix == nil {
            Util.showAlertDefaultOK(self, message: "invalid_input".localized)
            return
        }
        
        pix!.save = true
        
        self.requestDividaPayment(pixRequest: pix!)
    }
}

extension DividaPIXViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if fromClass == ViewPIX.self {
                if param == Param.Contact.SHOW_BACK_AND_CONTINUE_BUTTON {
                    self.viewContinue.showBackAndContinueButtons()
                }
                else if param == Param.Contact.SHOW_ONLY_BACK_BUTTON {
                    self.viewContinue.showOnlyBackButton()
                }
            }
            
            if fromClass == ViewPIXPersonCell.self {
                if param == Param.Contact.LIST_CLICK {
                    
                    let pix = object as! PIXRequest
                    let pr = PIXRequest()
                    
                    if pix.document == UserRN.getLoggedUser().cpf {
                        pr.name = ""
                        pr.document = ""
                    } else {
                        pr.name = pix.name
                        pr.document = pix.document
                    }
                    
                    pr.save = false
                    self.requestDividaPayment(pixRequest: pr)
                }
            }
            
            if fromClass == DividaRN.self {
                if param == Param.Contact.DIVIDA_PAY {
                    self.dismissPageAfter(after: 0.8)
                    self.setStatus(success: result)
                }
            }
        }
    }
}

extension DividaPIXViewController {
    
    func requestDividaPayment(pixRequest: PIXRequest) {
        Util.showLoading(self)
        DividaRN(delegate: self).payWithPIX(divida: self.selectedDivida, pixRequest: pixRequest)
    }
    
    func setStatus(success: Bool) {
        self.viewPIX.isHidden = true
        self.viewStatus.isHidden = false
        self.viewContinue.isHidden = true
        self.imgStatus.image = UIImage(named: success ? "ic_clock" : "ic_red_error")?.withRenderingMode(.alwaysTemplate)
        
        self.btnStatus.removeTarget(nil, action: nil, for: .allEvents)
        self.canExit = true
        
        if success {
            self.imgStatus.tintColor = Theme.default.yellow
            self.lbStatusTitle.text = "dividas_status_title_success".localized
            self.lbStatusDesc.text = "dividas_status_desc_success".localized
            
            Theme.default.yellowButton(self.btnStatus)
            
            self.viewPIXInfo.setValue(value: Util.doubleToInt(DividaDetailViewController.getValueToPay()))
            self.viewPIXInfo.isHidden = false
            
            self.btnStatus.addTarget(self, action: #selector(onClickFinishSuccess), for: .touchUpInside)
        }
        else {
            //self.imgStatus.tintColor = Theme.default.red
            self.lbStatusTitle.text = "dividas_status_title_failed".localized
            self.lbStatusDesc.text = "dividas_status_desc_failed".localized
            
            Theme.default.redButton(self.btnStatus)
            
            self.viewPIXInfo.isHidden = true
            self.btnStatus.addTarget(self, action: #selector(onClickFinishFailed), for: .touchUpInside)
        }
    }
}

extension DividaPIXViewController : SetupUI {
    
    func setupUI() {
        //Theme.default.textAsListTitle(self.lbTitle)
        self.viewContinue.showOnlyBackButton()
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "dividas_payment_pix".localized)
    }
    
    func setupNib() {
        
    }
}
