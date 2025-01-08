//
//  MenuTypeMain.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 04/07/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class MenuTypeMain: MenuTypeBaseView {
    
    // MARK: Outlets
    @IBOutlet weak var menuType1: MenuType1!
    @IBOutlet weak var menuType2: MenuType2!
    @IBOutlet weak var menuType3: MenuType3!
    
    @IBOutlet weak var stack1: UIStackView!
    @IBOutlet weak var stack2: UIStackView!
    @IBOutlet weak var stack3: UIStackView!
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "MenuTypeMain")
        self.setupInfo()
    }
}

extension MenuTypeMain {
    
    func defineMenu() {
        let imageView = UIImageView(image: UIImage(named: "menu_main_urbs"))
        
        let onClick1 = UITapGestureRecognizer(target: self, action: #selector(onClickMenu1))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(onClick1)
        
        self.stack1.addSubview(imageView)
    }
    
    @objc func onClickMenu1() {
        self.sendContact(position: 1)
    }
    
    func defineMenu2() {
        
        let terminalType = MenuItemRN.getTerminalType()
        self.menuType1.isHidden = true
        self.menuType2.isHidden = true
        self.menuType3.isHidden = true
        
        switch(terminalType) {
            
        case ActionFinder.TerminalType.RIBEIRAO_PRETO:
            self.menuType2.isHidden = false
            self.menuType2.menus = self.menus
            self.menuType2.delegate = self.delegate
            break
            
        case ActionFinder.TerminalType.CURITIBA:
            self.menuType3.isHidden = false
            self.menuType3.menus = self.menus
            self.menuType3.delegate = self.delegate
            break
            
        default:
            self.menuType1.isHidden = false
            self.menuType1.menus = self.menus
            self.menuType1.delegate = self.delegate
        }
    }
}

// MARK: Setup UI
extension MenuTypeMain {
    
    fileprivate func setupInfo() {
        
    }
}
