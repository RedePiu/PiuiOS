//
//  ViewReceipt.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 26/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewReceipt: LoadBaseView {

    // MARK: Outlets
    
    @IBOutlet weak var lbLabelReceipt: UILabel!
    @IBOutlet weak var textReceipt: UITextView!
    @IBOutlet weak var imageMore: UIImageView!
    @IBOutlet weak var imgTelesena: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewReceipt")
        self.setupViewReceipt()
        self.setupImageMore()
    }
    
    func setReceipt(receipt: String, isTelesena: Bool = false) {
        
        if receipt.isEmpty {
            self.isHidden = true
        }
        
        self.imgTelesena.isHidden = !isTelesena
        
        self.isHidden = false
        self.textReceipt.font = self.textReceipt.font!.withSize(12)
        //self.textReceipt.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        //self.updateTextFont()
        self.textReceipt.text = receipt
    }
    
    func updateTextFont() {
        if (textReceipt.text.isEmpty || textReceipt.bounds.size.equalTo(CGSize(width: 0, height: 0))) {
            return;
        }
        
        let textViewSize = textReceipt.frame.size;
        let fixedWidth = textViewSize.width;
        
        let expectSize = textReceipt.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));
        
        var expectFont = textReceipt.font;
        if (expectSize.height > textViewSize.height) {
            while (textReceipt.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textReceipt.font!.withSize(textReceipt.font!.pointSize - 1)
                textReceipt.font = expectFont
            }
        }
        else {
            while (textReceipt.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textReceipt.font;
                textReceipt.font = textReceipt.font!.withSize(textReceipt.font!.pointSize + 1)
            }
            textReceipt.font = expectFont;
        }
    }
}

extension ViewReceipt {
    
    fileprivate func setupViewReceipt() {
        Theme.OrderDetail.textAsLabel(self.lbLabelReceipt)
        Theme.default.textAsReceipt(self.textReceipt)
        
        self.imgTelesena.isHidden = true
        self.lbLabelReceipt.text = "order_receipt".localized
        self.textReceipt.text = "order_receipt_example".localized
    }
    
    fileprivate func setupImageMore() {
        
        self.imageMore.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
        self.imageMore.tintColor = Theme.default.white
    }
}
