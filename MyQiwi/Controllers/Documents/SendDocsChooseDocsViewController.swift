//
//  SendDocsChooseDocsViewController.swift
//  MyQiwi
//
//  Created by Ailton on 31/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class SendDocsChooseDocsViewController : UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewSendRG: UIView!
    @IBOutlet weak var viewSendCNH: UIView!
    @IBOutlet weak var viewSendRNE: UIView!
    @IBOutlet weak var viewSendRGWithCPF: UIView!
    @IBOutlet weak var viewSendRGWithoutCPF: UIView!
    
    @IBOutlet weak var btnBack: UIButton!
    
    var mDocType = 0
    
    // MARK: Ciclo de Vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.addTapsActions()
        
        self.hideAll()
    }
    
    override func setupViewWillAppear() {
        
        self.hideAll()
        self.viewSendRG.isHidden = false
        self.viewSendCNH.isHidden = false
        self.viewSendRNE.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SendDocsChooseDocsViewController {
    
}

extension SendDocsChooseDocsViewController {
    
    @IBAction func back(sender: Any) {
        if !self.viewSendCNH.isHidden {
            self.popPage()
            return
        }
        
        self.hideAll()
        self.viewSendRG.isHidden = false
        self.viewSendCNH.isHidden = false
        self.viewSendRNE.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.DOC_TAKE_PICTURE {
            
            // controller que sera apresentada
            if let navVC = segue.destination as? DocTakePictureViewController {
                // passa o pedido de order pra frente
                navVC.mDocType = self.mDocType
            }
        }
    }
}

extension SendDocsChooseDocsViewController {
    
    @objc func sendRG() {
        
        self.hideAll()
        
        viewSendRGWithCPF.isHidden = false
        viewSendRGWithoutCPF.isHidden = false
    }
    
    @objc func sendCNH() {

        self.mDocType = ActionFinder.Documents.Types.CNH
        performSegue(withIdentifier: Constants.Segues.DOC_TAKE_PICTURE, sender: nil)
    }
    
    @objc func sendRNE() {
        
        self.mDocType = ActionFinder.Documents.Types.RNE
        performSegue(withIdentifier: Constants.Segues.DOC_TAKE_PICTURE, sender: nil)
    }
    
    @objc func sendRGWithCPF() {
        
        self.mDocType = ActionFinder.Documents.Types.RG
        performSegue(withIdentifier: Constants.Segues.DOC_TAKE_PICTURE, sender: nil)
    }
    
    @objc func sendRGWithoutCPF() {
        
        self.mDocType = ActionFinder.Documents.Types.CPF
        performSegue(withIdentifier: Constants.Segues.DOC_TAKE_PICTURE, sender: nil)
    }
}

extension SendDocsChooseDocsViewController {
    
    func addTapsActions() {
        
        viewSendRG.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendRG)))
        viewSendCNH.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendCNH)))
        viewSendRNE.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendRNE)))
        viewSendRGWithCPF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendRGWithCPF)))
        viewSendRGWithoutCPF.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendRGWithoutCPF)))
    }
}

extension SendDocsChooseDocsViewController {
    
    func hideAll() {
        viewSendRG.isHidden = true
        viewSendCNH.isHidden = true
        viewSendRNE.isHidden = true
        viewSendRGWithCPF.isHidden = true
        viewSendRGWithoutCPF.isHidden = true
    }
}

extension SendDocsChooseDocsViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "app_name".localized)
    }
}
