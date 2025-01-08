//
//  TransportCardTutorialCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 03/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class TransportCardTutorialCell: UICollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imgCard: UIImageView!
    
    // MARK: Variables
    
    var item: TransportCardNumberTutorial! {
        
        didSet {
            self.imgCard.image = UIImage(named: self.item.frontImage)
        }
    }
}
