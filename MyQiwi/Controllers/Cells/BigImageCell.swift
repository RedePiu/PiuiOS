//
//  BigImageCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class BigImageCell: UIBaseCollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuTitle: UILabel?
    
    @IBOutlet weak var widthLayout: NSLayoutConstraint?
    
    // MARK: Variables
    
    var widthCollection: CGFloat = 120 {
        didSet {
            self.setCellWidth((widthCollection - (CGFloat(2) * 10)) / 2)
        }
    }
    
    // MARK: Methods
    
    func setCellWidth(_ width: CGFloat) {
        widthLayout?.constant = width
    }
    
    func displayContent(image: String) {
        //        let url = URL(string: Params.Net.URL + image)
        //        menuIcon.kf.setImage(with: url)
        
        let formattedImage = Util.formatImagePath(path: image)
        menuIcon.image = UIImage(named: formattedImage)
    }
    
    func displayContent(menu: MenuItem) {
        //        let url = URL(string: Params.Net.URL + menu.imageMenu)
        //        menuIcon.kf.setImage(with: url)
        
        let formattedImage = Util.formatImagePath(path: menu.imageMenu ?? "")
        menuIcon.image = UIImage(named: formattedImage)?.withRenderingMode(.alwaysTemplate)
        menuIcon.tintColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)
        
        if menuTitle != nil {
            menuTitle?.text = menu.desc
            menuIcon.tintColor = UIColor(red: 0/255, green: 118/255, blue: 188/255, alpha: 1)
        }
    }
}
