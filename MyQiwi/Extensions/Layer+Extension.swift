//
//  Layer+Extension.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

extension CALayer {
    
    func addShadow() {
        
        if cornerRadius != 0 {
            
            self.borderWidth = 0.5
            self.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
            
            self.shadowOffset = CGSize(width: 1, height: 3)
            self.shadowOpacity = 0.5
            self.shadowRadius = 2
            self.shadowColor = UIColor.black.withAlphaComponent(0.34).cgColor
            
            self.masksToBounds = false
            
            addShadowWithRoundedCorners()
        }
    }
    func roundCorners(radius: CGFloat) {
        if radius != 0 {
            self.cornerRadius = radius
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == "CustomLayer" {
                
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = "CustomLayer"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
}
