//
//  MessageCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 20/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class MessageCell: UIBaseTableViewCell {
    
    @IBOutlet weak var lbBody: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var leadingBubble: NSLayoutConstraint!
    @IBOutlet weak var trailingBubble: NSLayoutConstraint!
    
    @IBOutlet weak var leadingGreaterBubble: NSLayoutConstraint!
    @IBOutlet weak var trailingGreaterBubble: NSLayoutConstraint!
    
    var message: Message! {
        
        didSet {
            
            lbBody.text = message.body
            lbTime.text = message.time
            
            lbBody.font = FontCustom.helveticaRegular.font(16)
            lbTime.font = FontCustom.helveticaRegular.font(11)
            
            lbBody.textColor = .black
            lbTime.textColor = UIColor(hexString: Constants.Colors.Hex.colorChatTime)
            
            lbBody.superview?.layer.borderWidth = 1
            lbBody.superview?.layer.cornerRadius = 0
            lbBody.superview?.layer.masksToBounds = false
            
            backgroundColor = .clear
            
            // Constraints
            
            if message.isMine {
                
                lbBody.superview?.backgroundColor = #colorLiteral(red: 0.9369294643, green: 1, blue: 0.8695169091, alpha: 1)
                lbBody.superview?.layer.borderColor = UIColor(red: 0.5894249082, green: 0.7350147963, blue: 0.5359187126, alpha: 0.1).cgColor
                
                leadingBubble.isActive = false
                leadingGreaterBubble.isActive = !leadingBubble.isActive
                trailingBubble.isActive = true
                trailingGreaterBubble.isActive = !trailingBubble.isActive
                
                
            }else {
                
                lbBody.superview?.backgroundColor = .white
                lbBody.superview?.layer.borderColor = UIColor.darkGray.withAlphaComponent(0.1).cgColor
                
                leadingBubble.isActive = true
                leadingGreaterBubble.isActive = !leadingBubble.isActive
                
                trailingBubble.isActive = false
                trailingGreaterBubble.isActive = !trailingBubble.isActive
                
            }
            
            self.layoutIfNeeded()
        }
    }
}
