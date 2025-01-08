//
//  ConsultCPFViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 15/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ConsultCPFViewController: UIBaseViewController {
    
    
    @IBOutlet weak var btnBack: UIButton!
    //@IBOutlet weak var btnContinue: UIButton!
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
}

extension ConsultCPFViewController: SetupUI{
    func setupUI() {
        Theme.default.backgroundCard(self)
        //Theme.default.orageButton(self.btnBack)
        //Theme.default.greenButton(self.btnContinue)
    }
    
    func setupTexts() {
        //self.btnBack.setTitle("back".localized, for: .normal)
        //self.btnContinue.setTitle("continue_label".localized, for: .normal)
        
        //Theme.default.textAsListTitle(self.lbTitle)
        Util.setTextBarIn(self, title: "cpf_consult_toolbar_title".localized)
    }
}
