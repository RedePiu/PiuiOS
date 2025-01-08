//
//  SendDocsIntroViewController.swift
//  MyQiwi
//
//  Created by Ailton on 31/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class SendDocsIntroViewController : UIBaseViewController {
    
    // MARK: Ciclo de Vida
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
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
        performSegue(withIdentifier: Constants.Segues.SEND_DOCUMENTS_CHOOSE_DOCS, sender: nil)
    }
}

extension SendDocsIntroViewController {
    
}

extension SendDocsIntroViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.blueButton(self.btnContinue)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "Enviar documento")
    }
}
