//
//  ImageWithTextCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ImageWithTextCell: UIBaseCollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuTitle: UILabel?
    @IBOutlet weak var lbNotAvailable: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    func displayContent(image: String) {
        
        let formattedImage = Util.formatImagePath(path: image)
        menuIcon.image = UIImage(named: formattedImage)
    }
    
    func displayContent(menu: MenuItem) {
        
        let formattedImage = Util.formatImagePath(path: menu.imageMenu ?? "")
        menuIcon.image = UIImage(named: formattedImage)?.withRenderingMode(.alwaysTemplate)
        menuIcon.tintColor = Theme.default.primary
        
        if menuTitle != nil {
            menuTitle?.text = menu.desc
//            menuTitle?.font = FontCustom.helveticaRegular.font(17)
            menuTitle?.adjustsFontForContentSizeCategory = true
            menuIcon.tintColor = UIColor(red: 0/255, green: 118/255, blue: 188/255, alpha: 1)
            
            lbNotAvailable.isHidden = !menu.notAvailable
            viewBG.isHidden = !menu.notAvailable
            
            if menu.notAvailable {
                let maxPrice = menu.data as! Int
                lbNotAvailable.text = "Máx: " + Util.formatCoin(value: maxPrice)
            }
//            Log.print(menuTitle!.font.familyName)
        }
    }
}
