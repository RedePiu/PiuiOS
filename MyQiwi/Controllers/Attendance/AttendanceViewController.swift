//
//  AttendanceViewController.swift
//  MyQiwi
//
//  Created by ailton on 21/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import UIKit

class AttendanceViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var ivMascot: UIImageView!
    @IBOutlet weak var itsMessage: UILabel!
    
    @IBOutlet weak var lbPhoneTitle: UILabel!
    @IBOutlet weak var lbPhoneDesc: UILabel!
    @IBOutlet weak var lbWhatsAppTitle: UILabel!
    @IBOutlet weak var lbWhatsAppDesc: UILabel!
    
    // MARK: Variables
    
    var menuItems = MenuItemRN().getAttendanceList()
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        ivMascot.transform = ivMascot.transform.rotated(by: CGFloat(31))
        
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        Util.setLogoBarIn(self)
        self.tabBarController?.delegate = self
        
        if UserRN.hasLoggedUser() {
            // Logado
        }else {
            Util.showNeedLogin(self)
        }
    }
    
    @IBAction func onClickWhatsapp(_ sender: Any) {
        Util.openWhatsApp(number: "5511976487787", msg: "attendance_whatsapp_msg".localized.replacingOccurrences(of: "{NAME}", with: UserRN.getLoggedUser().name))
    }
    
    @IBAction func onClickPhone(_ sender: Any) {
        guard let number = URL(string: "tel://1140032989") else { return }
        UIApplication.shared.open(number)
    }
}

// MARK: Delegate TabBar
extension AttendanceViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UserRN.hasLoggedUser() {
            Util.removeNeedLogin(self)
        }
    }
}

// MARK: Custom Mehtods
extension AttendanceViewController {
    
    func isLogged() {
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
        
        //self.performSegue(withIdentifier: "CHAT", sender: nil)
    }
}

// MARK: SetupUI
extension AttendanceViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.Attendance.textAsMessage(self.lblMessage)
    }
    
    func setupTexts() {
        
        self.lblMessage.text = "attendance_title".localized
        
        self.lbPhoneTitle.text = "attendance_phone_title".localized
        self.lbPhoneDesc.text = "attendance_phone_desc".localized
        self.lbWhatsAppTitle.text = "attendance_whatsapp_title".localized
        self.lbWhatsAppDesc.text = "attendance_whatsapp_desc".localized
    }
}
