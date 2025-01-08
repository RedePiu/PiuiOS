//
//  HomeViewCell.swift
//  MyQiwi
//
//  Created by ailton on 14/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class MenuItemViewCell: UIBaseCollectionViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuTitle: UILabel?
    
    // MARK: Methods
    
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
        menuIcon.image = UIImage(named: formattedImage)
        
        if menuTitle != nil {
            menuTitle?.text = menu.desc
            menuIcon.tintColor = UIColor(red: 0/255, green: 118/255, blue: 188/255, alpha: 1)
        }
    }
}
