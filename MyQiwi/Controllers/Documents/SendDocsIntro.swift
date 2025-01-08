//
//  SendDocsIntro.swift
//  MyQiwi
//
//  Created by Ailton on 31/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class SendDocsIntroViewController : UIBaseViewController {

    // MARK: Ciclo de Vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        
        self.hideAll()
        
        self.lbEmpty.superview?.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NotificationViewController {
    
    func hideAll() {
        self.tableView.superview?.isHidden = true
        self.lbEmpty.superview?.isHidden = true
    }
}

extension NotificationViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsMessage(self.lbEmpty)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "notification_toolbar_title".localized)
        self.lbEmpty.text = "notification_no_content".localized
    }
}
