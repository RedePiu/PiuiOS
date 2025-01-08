//
//  ParkingRuleViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 28/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class ParkingRuleViewController: UIBaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var descRuleOne: UILabel!
    @IBOutlet weak var bntPark: UIButton!
    @IBOutlet weak var txtVerify: UILabel!
    @IBOutlet weak var viewWarning: ViewWarning!
    @IBOutlet weak var btnBack: UIButton!
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
}

extension ParkingRuleViewController{
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lblTitle)
        Theme.default.textAsListTitle(self.lblCall)
        Theme.default.greenButton(self.bntPark)
        Theme.default.orageButton(self.btnBack)
        
        self.setupViewWarning()
    }
    
    func setupViewWarning() {
        
        self.viewWarning.backgroundColor = Theme.default.orange
        self.viewWarning.imgIcon.image = UIImage(named: "ic_warning")?.withRenderingMode(.alwaysTemplate)
        self.viewWarning.imgIcon.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "parking_title_nav".localized)
        self.lblTitle.text = "parking_confirm_rule".localized
        self.lblCall.text = "parking_lable_general_rule".localized
        self.descRuleOne.text = "parking_rule_general_desc".localized
        self.bntPark.setTitle("parking_button_active".localized, for: .normal)
        self.btnBack.setTitle("back".localized, for: .normal)
        self.viewWarning.lbDesc.text =  "parking_verify_time".localized
    }
}
