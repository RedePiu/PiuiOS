//
//  CollectionViewCell+Extension.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    class func Identifier() -> String {
        return "\(self)"
    }
    
    class func nib() -> UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }
}

extension UITableViewCell {
    
    class func nib() -> UINib {
        return UINib(nibName: "\(self)", bundle: nil)
    }
}
