//
//  ProdutCardMenu.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

// MARK: UICollectionViewCell
class ProductCardMenu: UICollectionViewCell {
    
    @IBOutlet weak var imgMenuItem: UIImageView!
    
    var imageMenu: String! {
        didSet {
            self.displayContent(image: imageMenu)
        }
    }
    
    func displayContent(image: String) {
        self.imgMenuItem.image = UIImage(named: image)
    }
}
