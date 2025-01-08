//
//  Label+Extension.swift
//  MyQiwi
//
//  Created by Douglas on 04/05/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setupTitleBold() {
        
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.font = FontCustom.helveticaBold.font(20)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setupTitleMedium() {
        
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.font = FontCustom.helveticaMedium.font(18)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setupTitleMediumAccountQiwiDate() {
        
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.font = FontCustom.helveticaMedium.font(14)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setupTitleMediumAccountQiwiBalance() {
        
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.font = FontCustom.helveticaRegular.font(14)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setupDefaultTextStyle() {
        
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.font = FontCustom.helveticaRegular.font(14)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setupTitleNormal() {
        
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiDark)
        self.font = FontCustom.helveticaRegular.font(18)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setupTitleBoldSmall() {
        
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.font = FontCustom.helveticaBold.font(14)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setupMessageMedium() {
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.font = FontCustom.helveticaMedium.font(16)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setupMessageNormal() {
        
        self.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.font = FontCustom.helveticaRegular.font(16)
        self.adjustsFontForContentSizeCategory = true
    }
}
