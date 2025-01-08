//
//  InfoAppViewController.swift
//  MyQiwi
//
//  Created by Douglas on 04/05/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class InfoAppViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var lbInfo: UILabel!
    @IBOutlet weak var lbNameApp: UILabel!
    @IBOutlet weak var lbVersionApp: UILabel!
    @IBOutlet weak var lbTerminal: UILabel!
    @IBOutlet weak var lbContactQiwi: UILabel!
    @IBOutlet weak var btnAppleStore: UIButton!
    @IBOutlet weak var lbInfoOtherCards: UILabel!
    @IBOutlet weak var lbInfoNotication: UILabel!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var lbInfoPasswordVisibility: UILabel!
    @IBOutlet weak var btnPasswordVisibility: UIButton!
    @IBOutlet weak var imgSwitch: UIImageView!
    @IBOutlet weak var imgSwitchPasswordVisibility: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lbTime: UILabel!
    
    // MARK: Variables
    
    var isNotification: Bool = false
    var passVisibility: Bool = false
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        //
        self.slider.minimumValue = 10
        self.slider.maximumValue = 25
        
        self.passVisibility = PassVisibility.needChangeToAll()
        self.imgSwitchPasswordVisibility.image = self.passVisibility ? #imageLiteral(resourceName: "switch_on") : #imageLiteral(resourceName: "switch_off")
    }
    
    override func setupViewWillAppear() {
    }
}

// MARK: IBActions

extension InfoAppViewController {
    
    @IBAction func openTerms() {
        // Termos de uso
        Util.showPopupWebView(self)
    }
    
    @IBAction func openAppleStore() {
        Util.openAppleStore()
    }
    
    @IBAction func enableNotitification() {
        self.isNotification = !self.isNotification
        self.imgSwitch.image = self.isNotification ? #imageLiteral(resourceName: "switch_on") : #imageLiteral(resourceName: "switch_off")
    }
    
    @IBAction func enableNPassVisibility() {
        self.passVisibility = !self.passVisibility
        self.imgSwitchPasswordVisibility.image = self.passVisibility ? #imageLiteral(resourceName: "switch_on") : #imageLiteral(resourceName: "switch_off")
        
        PassVisibility.setNeedChangeAll(needChange: self.passVisibility)
    }
    
    @IBAction func changeTime(sender: UISlider) {
        self.lbTime.text = "\(Int(sender.value))"
    }
}

// MARK: SetupUI

extension InfoAppViewController {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbInfo)
        Theme.default.textAsListTitle(self.lbInfoOtherCards)
        
        Theme.InfoApp.textAsNotificarionApp(self.lbInfoNotication)
        Theme.InfoApp.textAsNotificarionApp(self.lbInfoPasswordVisibility)
        Theme.InfoApp.textAsNameApp(self.lbNameApp)
        Theme.InfoApp.textAsVersionApp(self.lbVersionApp)
        Theme.InfoApp.textAsTerminalApp(self.lbTerminal)
        Theme.InfoApp.textAsTerminalApp(self.lbContactQiwi)
        
        self.btnAppleStore.setTitleColor(UIColor(hexString: Constants.Colors.Hex.colorGrey6), for: .normal)
        self.btnNotification.setTitleColor(UIColor(hexString: Constants.Colors.Hex.colorGrey6), for: .normal)
        self.btnPasswordVisibility.setTitleColor(UIColor(hexString: Constants.Colors.Hex.colorGrey6), for: .normal)
        self.btnAppleStore.titleLabel?.font = FontCustom.helveticaRegular.font(15)
        self.btnNotification.titleLabel?.font = FontCustom.helveticaRegular.font(15)
        self.btnPasswordVisibility.titleLabel?.font = FontCustom.helveticaRegular.font(15)
    }
    
    func setupTexts() {
        
        self.lbInfo.text = "app_info_first_title".localized
        self.lbNameApp.text = "app_name".localized
        
        self.lbVersionApp.text = "app_info_version".localized
            .replacingOccurrences(of: "{version}", with: Constants.version)
        
        self.lbTerminal.text = "app_info_terminal_number".localized
            .replacingOccurrences(of: "{number}", with: "\(SQiwi.tC())")
        
        self.lbContactQiwi.text = "app_info_contact".localized
        self.btnAppleStore.titleLabel?.text = "app_info_playstore_page".localized
        self.lbInfoNotication.text = "settings_notification_title".localized
        self.btnNotification.titleLabel?.text = "settings_notification_order_status".localized
        self.lbInfoPasswordVisibility.text = "settings_pass_visibility_title".localized
        self.btnPasswordVisibility.titleLabel?.text = "settings_pass_visibility".localized
        self.lbInfoOtherCards.text = "app_info_second_title".localized
        Util.setTextBarIn(self, title: "app_info_toolbar_title".localized)
    }
}
