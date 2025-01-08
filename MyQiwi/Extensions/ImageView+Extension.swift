//
//  ImageView+Extension.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setImage(named: String) {
        self.image = UIImage(named: named)
    }
    
    func setImageForTint(named: String) {
        self.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
    }
    
    func setImageAndTint(named: String, color: UIColor) {
        self.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func setupBlue() {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor(hexString: Constants.Colors.Hex.colorButtonBlue)
    }
    
    func setupRed() {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor(hexString: Constants.Colors.Hex.colorButtonRed)
    }
    
    func setupOrage() {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor(hexString: Constants.Colors.Hex.colorButtonOrange)
    }
    
    func setupGreen() {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = UIColor(hexString: Constants.Colors.Hex.colorButtonGreen)
    }
    
    func changeImageAfter(imageName: String, after: Double) {
        changeImageAfter(image: UIImage(named: imageName)!, after: after)
    }
    
    func changeImageAfter(image: UIImage, after: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: {
            self.image = image
        })
    }
}
