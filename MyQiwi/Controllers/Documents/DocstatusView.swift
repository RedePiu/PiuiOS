//
//  DocstatusView.swift
//  MyQiwi
//
//  Created by Ailton on 24/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class DocstatusView : UIBaseViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbReason: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var viewReason: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnDontSee: UIButton!
    
    // MARK: Variables
    
    lazy var documentRN = DocumentsRN(delegate: self)
    var documentProcess: DocumentProcess?
    var mWillSendagain = false

    // MARK: Ciclo de Vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        
    }
    
    @IBAction func onClickDontSend(_ sender: Any) {
    
    }
}

extension DocstatusView {
    func switchViews() {

        if self.documentProcess?.status == ActionFinder.Documents.Status.APROVADO {
            
            self.ivIcon.image = UIImage(named: "ic_approved")
            self.lbTitle.text = "docs_status_approved".localized
            self.btnContinue.text("docs_keep_shopping".localized)
            Theme.default.greenButton(self.btnContinue)
            
            self.btnDontSee.isHidden = true
            self.viewReason.isHidden = true
            
            let desc = "docs_status_approved_desc".localized.replacingOccurrences(of: "{number}", with: (self.documentProcess?.cardNumber)!)
            self.lbDesc.text = desc
            return
        }
        
        self.ivIcon.image = UIImage(named: "ic_denied")
        self.lbTitle.text = "docs_status_denied".localized
        self.btnContinue.setTitle("docs_send_again".localized)
        Theme.default.redButton(self.btnContinue)
        
        var desc = ""
        if self.documentProcess?.cardNumber != nil && !(self.documentProcess?.cardNumber.isEmpty)! {
            desc = "docs_status_denied_desc".localized.replacingOccurrences(of: "{number}", with: (self.documentProcess?.cardNumber)!)
        } else {
            desc = "docs_status_denied_desc".localized.replacingOccurrences(of: "{number}", with: "")
        }
        
        self.lbDesc.text = desc
        
        self.btnDontSee.isHidden = false
        self.viewReason.isHidden = false
        self.putReasonOnScreen()
    }
    
    func putReasonOnScreen() {
        var reason = ""
        
        if self.documentProcess?.documents != nil {
            for i in (self.documentProcess?.documents.enumerated())! {
                reason = reason + i.element.obs
                
                if i.offset != (self.documentProcess?.documents.count)! - 1 {
                    reason = reason + "\n"
                }
            }
        }
        
        self.lbReason.text = reason
    }
}

// MARK: SetupUI
extension DocstatusView: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if fromClass == DocumentsRN.self {
                if (param == Param.Contact.DOCS_DOCUMENT_SEEN_RESPONSE) {
                    
                    if (self.mWillSendagain) {
                        if (UserRN.hasApprovedDocs()) {
                            self.startEditCreditCardActivity();
                        } else {
                            self.startDocFlowActivity();
                        }
                    }
                }
            }
        }
    }
}

// MARK: SetupUI
extension DocstatusView {
    
    func startEditCreditCardActivity() {
        
    }
    
    func startDocFlowActivity() {
        
    }
}

// MARK: SetupUI
extension DocstatusView: SetupUI {
    
    func setupUI() {
        
    }
    
    func setupTexts() {
        
    }
}
