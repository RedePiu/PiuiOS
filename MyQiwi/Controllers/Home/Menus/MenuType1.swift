//
//  MenuType1.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/07/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class MenuType1: MenuTypeBaseView {
    
    // MARK: Outlets
    @IBOutlet weak var imgMenu1: UIImageView!
    @IBOutlet weak var imgMenu2: UIImageView!
    @IBOutlet weak var imgMenu3: UIImageView!
    @IBOutlet weak var imgMenu4: UIImageView!
    @IBOutlet weak var imgMenu5: UIImageView!
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "MenuType1")
        self.setupInfo()
    }
    
    override func setupMenus(menus: [MenuItem]) {
        super.setupMenus(menus: menus)
        
        self.imgMenu1.setImage(named: Util.formatImagePath(path: menus[0].imageMenu!))
        self.imgMenu2.setImage(named: Util.formatImagePath(path: menus[1].imageMenu!))
        self.imgMenu3.setImage(named: Util.formatImagePath(path: menus[2].imageMenu!))
        self.imgMenu4.setImage(named: Util.formatImagePath(path: menus[3].imageMenu!))
        self.imgMenu5.setImage(named: Util.formatImagePath(path: menus[4].imageMenu!))
    }
}

extension MenuType1 {
    
    @IBAction func onClickMenu1(_ sender: Any) {
        self.sendContact(position: 1)
    }
    
    @IBAction func onClickMenu2(_ sender: Any) {
        self.sendContact(position: 2)
    }
    
    @IBAction func onClickMenu3(_ sender: Any) {
        self.sendContact(position: 3)
    }
    
    @IBAction func onClickMenu4(_ sender: Any) {
        self.sendContact(position: 4)
    }
    
    @IBAction func onClickMenu5(_ sender: Any) {
        self.sendContact(position: 5)
    }
}

// MARK: Setup UI
extension MenuType1 {
    
    fileprivate func setupInfo() {
       
    }
}
