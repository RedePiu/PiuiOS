//
//  ViewCheckbox.swift
//  MyQiwi
//
//  Created by Ailton on 18/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewCheckbox: LoadBaseView {
    
    // MARK: Views
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lbText: UILabel!
    
    // MARK: Variables
    var isChecked = true
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewCheckbox")
        self.setupView()
    }
    
    @IBAction func onClickCheck(_ sender: Any) {
        self.setChecked(checked: !self.isChecked)
    }
}

extension ViewCheckbox {
    
    @objc
    func onClickLabel(sender:UITapGestureRecognizer) {
        self.setChecked(checked: !self.isChecked)
    }
}

extension ViewCheckbox {
    
    func setupView() {

        self.lbText.setupMessageNormal()
        self.setChecked(checked: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickLabel))
        lbText.isUserInteractionEnabled = true
        lbText.addGestureRecognizer(tap)
    }
    
    func setChecked(checked: Bool) {
        self.isChecked = checked
        
        if !isChecked {
            self.btnCheck.setImage(Constants.Image.Button.CHECK_BOX_DISABLED, for: .normal)
            self.btnCheck.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            return
        }
        
        self.btnCheck.setImage(Constants.Image.Button.CHECK_BOX_ENABLE, for: .normal)
        self.btnCheck.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorAccent)
    }
}
