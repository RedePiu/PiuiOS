//
//  DocStatusViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class DocStatusViewController: UIBaseViewController {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbReason: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnDontSee: UIButton!
    
    lazy var documentRN = DocumentsRN(delegate: self)
    static var mDocumentProcess = DocumentProcess()
    var willSendAgain = false
    var alreadyEnteredHere = false
    var action = 0
    
    let ACTION_CLOSE = 1
    let ACTION_GO_TO_DOCS = 1
    
    // MARK: Ciclo de Vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.switchViews()
    }
    
    override func setupViewWillAppear() {
        if self.alreadyEnteredHere {
            self.dismissPageAfter(after: 0.2)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DocStatusViewController {
    
    func setSeen() {
        Util.showLoading(self) {
            self.documentRN.setSeen(processId: DocStatusViewController.mDocumentProcess.processId)
        }
    }
    
    func switchViews() {
        if DocStatusViewController.mDocumentProcess.status == ActionFinder.Documents.Status.APROVADO {
            
            imgIcon.image = UIImage(named: "ic_approved")
            self.lbTitle.text = "docs_status_approved".localized
            
            self.btnContinue.setTitle("docs_keep_shopping".localized)
            Theme.default.greenButton(self.btnContinue)
            
            let desc = "docs_status_approved_desc".localized.replacingOccurrences(of: "{number}", with: DocStatusViewController.mDocumentProcess.cardNumber)
            
            self.lbDesc.text = desc
            
            self.btnDontSee.isHidden = true
            self.lbReason.isHidden = true
            btnContinue.addTarget(self, action: #selector(self.continueShopping), for: .touchUpInside)
            return
        }

        imgIcon.image = UIImage(named: "ic_denied")
        self.lbTitle.text = "docs_status_denied".localized
        
        self.btnContinue.setTitle("docs_send_again".localized)
        Theme.default.redButton(self.btnContinue)
        
        var desc = "docs_status_approved_desc".localized.replacingOccurrences(of: "{number}", with: DocStatusViewController.mDocumentProcess.cardNumber)
        
        if (!DocStatusViewController.mDocumentProcess.cardNumber.isEmpty) {
            desc = "docs_status_denied_desc".localized.replacingOccurrences(of: "{number}", with: " (final " + DocStatusViewController.mDocumentProcess.cardNumber + ")")
        } else {
            desc = "docs_status_denied_desc".localized.replacingOccurrences(of: "{number}", with: "")
        }
        
        self.lbDesc.text = desc
        self.btnDontSee.isHidden = false
        self.lbReason.isHidden = false

        self.putReasonOnScreen();
        
        btnContinue.addTarget(self, action: #selector(self.sendAgain), for: .touchUpInside)
    }
    
    func putReasonOnScreen() {
        var reason = ""
        
        if !DocStatusViewController.mDocumentProcess.documents.isEmpty {
            
            for i in 0..<DocStatusViewController.mDocumentProcess.documents.count {
                reason = reason + DocStatusViewController.mDocumentProcess.documents[i].obs
                
                if i != DocStatusViewController.mDocumentProcess.documents.count - 1 {
                    reason = reason + "\n"
                }
            }
        }
        
        self.lbReason.text = reason
    }
}

extension DocStatusViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            if param == Param.Contact.DOCS_DOCUMENT_SEEN_RESPONSE {
                self.alreadyEnteredHere = true
                self.dismiss(animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.willSendAgain {
                        if UserRN.hasApprovedDocs() {
                            
                            // Abre fluxo do Storyboard
                            Util.showStoryboard(self, name: "Documents")
                        }
                        else {
                            
                            // Abre fluxo do Storyboard padr
                            Util.showStoryboard(self, name: "SendDocuments")
                        }
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}

extension DocStatusViewController {
    
    @objc func continueShopping() {
        self.dismissPage(nil)
    }
    
    @objc func sendAgain() {
        self.willSendAgain = true
        self.setSeen()
    }
    
    @objc func dontSeeAgain() {
        self.willSendAgain = false
        self.setSeen()
    }
}

extension DocStatusViewController: SetupUI {
    
    func setupUI() {
        Theme.default.blueButton(self.btnDontSee)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsDescForPopup(self.lbDesc)
    }
    
    func setupTexts() {
        self.btnDontSee.setTitle("docs_dont_show".localized)
        
        btnDontSee.addTarget(self, action: #selector(self.dontSeeAgain), for: .touchUpInside)
    }
}
