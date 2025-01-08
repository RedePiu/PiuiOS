//
//  ViewEmpty.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 26/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewEmpty: LoadBaseView {

    // MARK: Outlets
    
    @IBOutlet weak var lbEmpty: UILabel!
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewEmpty")
        self.setupViewEmpty()
    }
}

// MARK: Setup UI
extension ViewEmpty {
    
    fileprivate func setupViewEmpty() {
        Theme.default.textAsMessage(self.lbEmpty)
    }
}
