//
//  OtherGenericCollectionViewCell.swift
//  MyQiwi
//
//  Created by Douglas on 15/05/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class OtherGenericCollectionViewCell: UICollectionViewCell {

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

}
