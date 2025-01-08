//
//  MenuType3.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/07/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class MenuType3: MenuTypeBaseView {
    
    // MARK: Outlets
    @IBOutlet weak var imgMenu1: UIImageView!
    @IBOutlet weak var imgMenu2: UIImageView!
    @IBOutlet weak var imgMenu3: UIImageView!
    @IBOutlet weak var imgMenu4: UIImageView!
    @IBOutlet weak var imgMenu5: UIImageView!
    @IBOutlet weak var imgMenu6: UIImageView!
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "MenuType3")
        self.setupInfo()
    }
    
    override func setupMenus(menus: [MenuItem]) {
        super.setupMenus(menus: menus)
        
        self.imgMenu1.setImage(named: Util.formatImagePath(path: menus[0].imageMenu!))
        self.imgMenu2.setImage(named: Util.formatImagePath(path: menus[1].imageMenu!))
        self.imgMenu3.setImage(named: Util.formatImagePath(path: menus[2].imageMenu!))
        self.imgMenu4.setImage(named: Util.formatImagePath(path: menus[3].imageMenu!))
        self.imgMenu5.setImage(named: Util.formatImagePath(path: menus[4].imageMenu!))
        self.imgMenu6.setImage(named: Util.formatImagePath(path: menus[5].imageMenu!))
    }
}

extension MenuType3 {
    
    @objc func onClickMenu1() {
        self.sendContact(position: 1)
    }
    
    @objc func onClickMenu2() {
        self.sendContact(position: 2)
    }
    
    @objc func onClickMenu3() {
        self.sendContact(position: 3)
    }
    
    @IBAction func onClickMenu4(_ sender: Any) {
        self.sendContact(position: 4)
    }
    
    @IBAction func onClickMenu5(_ sender: Any) {
        self.sendContact(position: 1)
    }
    
    @IBAction func onClickMenu6(_ sender: Any) {
        self.sendContact(position: 1)
    }
}

// MARK: Setup UI
extension MenuType3 {
    
    fileprivate func setupInfo() {
        let onClick1 = UITapGestureRecognizer(target: self, action: #selector(onClickMenu1))
        self.imgMenu1.isUserInteractionEnabled = true
        self.imgMenu1.addGestureRecognizer(onClick1)
        
        let onClick2 = UITapGestureRecognizer(target: self, action: #selector(onClickMenu2))
        self.imgMenu2.isUserInteractionEnabled = true
        self.imgMenu2.addGestureRecognizer(onClick2)
        
        let onClick3 = UITapGestureRecognizer(target: self, action: #selector(onClickMenu3))
        self.imgMenu3.isUserInteractionEnabled = true
        self.imgMenu3.addGestureRecognizer(onClick3)
    }
}
