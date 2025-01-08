//
//  ItemTopApps.swift
//  MyQiwi
//
//  Created by Daniel Catini on 02/10/23.
//  Copyright © 2023 Qiwi. All rights reserved.
//

import UIKit

class ItemTopApps: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    var imgMenu: String! {
        didSet {
            self.displayContent(image: imgMenu)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func displayContent(image: String) {
        img.image = UIImage(named: image)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        img.layer.shadowColor = UIColor.gray.cgColor
        img.layer.shadowOpacity = 0.5
        img.layer.shadowRadius = 3
        img.layer.shadowOffset = CGSize(width: 0, height: 4)
        img.layer.masksToBounds = false
    }

}
