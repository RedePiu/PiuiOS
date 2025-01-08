//
//  ViewWarning.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewWarning: LoadBaseView {

    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbDesc: UILabel!
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewWarning")
        self.setupViewWarning()
    }
}

extension ViewWarning {
    
    func setupViewWarning() {
        
        self.backgroundColor = Theme.default.red
        self.setupViewCard()
        
        self.lbDesc.setupMessageNormal()
        self.lbDesc.textColor = Theme.default.white
        
        self.imgIcon.image = #imageLiteral(resourceName: "ic_warning").withRenderingMode(.alwaysTemplate)
        self.imgIcon.tintColor = Theme.default.white
    }
}
