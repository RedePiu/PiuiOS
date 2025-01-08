//
//  LoadBaseView.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 25/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class LoadBaseView: UIView {

    // MARK: Variables
    
    @IBInspectable var isCard: Bool = true {
        
        didSet {
            // Ativado por padrão
            if isCard {
                self.setupViewCard()
            }
        }
    }
    
    // MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initCoder()
    }
    
    func initCoder() {
    }
}

// MARK: Setup Stack
extension LoadBaseView {
    
    fileprivate func setupStackView(_ stack: UIStackView) {
        
        if let stackSuperView = self.subviews.first as? UIStackView {
            stackSuperView.addArrangedSubview(stack)
        }
    }
}

// MARK: Load Nib
extension LoadBaseView {
    
    func loadNib(name: String) {
        
        if let view = Bundle.main.loadNibNamed(name, owner: self, options: nil) as? [UIView] {
            if let stackViewXib = view.first as? UIStackView {
                self.setupStackView(stackViewXib)
            }
        }
    }
}
