//
//  ConsultCNPJViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 15/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ConsultCNPJViewController: UIBaseViewController {

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }

}

extension ConsultCNPJViewController: SetupUI{
    func setupUI() {
        Theme.default.backgroundCard(self)
        //Theme.default.orageButton(self.btnBack)
        //Theme.default.greenButton(self.btnContinue)
    }
    
    func setupTexts() {
        //self.btnBack.setTitle("back".localized, for: .normal)
        //self.btnContinue.setTitle("continue_label".localized, for: .normal)
        
        //Theme.default.textAsListTitle(self.lbTitleCnpj)
        Util.setTextBarIn(self, title: "cnpj_consult_toolbar_title".localized)
    }
}
