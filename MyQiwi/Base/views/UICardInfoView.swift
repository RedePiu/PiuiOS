//
//  UICardInfoView.swift
//  charadesapp
//
//  Created by Ailton Ramos on 04/02/20.
//  Copyright © 2020 Ailton Ramos. All rights reserved.
//

import UIKit

class UICardInfoView : LoadBaseView {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    // MARK : VARIABLES
    var delegate: BaseDelegate?
    
    override func initCoder() {
        self.loadNib(name: "UICardInfoView")
        self.setupView()
    }
    
    @IBAction func onClickButton(_ sender: Any) {
        self.delegate?.onReceiveData(fromClass: UICardInfoView.self, param: Param.Contact.ITEM_CLICK, result: true, object: nil)
    }
}

extension UICardInfoView {
    
    func setupView() {
        Theme.default.textAsListTitle(lbTitle)
        lbDesc.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        
        Theme.default.blueButton(btn)
    }
    
    func setCardInfo(title: String, desc: String, icon: String, button: String) {
        self.imgIcon.setImage(named: icon)
        self.lbTitle.text = title
        self.lbDesc.text = desc
        self.btn.setTitle(button)
    }
}
