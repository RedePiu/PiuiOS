//
//  PageViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class PageViewController: UIBaseViewController {

    // MARK: Outlets
    
    var lblMessage = UILabel()
    
    // MARK: Variables
    
    lazy var index = 0
    var textMessage = ""
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        self.setupMessagem()
        self.setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: SetupUI
extension PageViewController: SetupUI {
    
    func setupUI() {
        
        self.view.backgroundColor = UIColor.clear
        self.lblMessage.setupTitleMedium()
    }
    
    func setupTexts() {
        self.lblMessage.text = textMessage
    }
}


// MARK: Config UI
extension PageViewController {
    
    func setupMessagem() {
        
        self.lblMessage.textAlignment = .center
        self.lblMessage.numberOfLines = 0
        
        self.view.addSubview(self.lblMessage)
    }
    
    func setupConstraints() {
        
        self.lblMessage.translatesAutoresizingMaskIntoConstraints = false
        
        self.lblMessage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.lblMessage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.lblMessage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
    
}
