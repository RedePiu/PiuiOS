//
//  PresentationCard.swift
//  MyQiwi
//
//  Created by Thiago Silva on 21/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

//class PresentationCardCell: UITableViewCell {
class PresentationCardCell: LoadBaseView {

    @IBOutlet weak var imgPhoneUser: UIImage!
    @IBOutlet weak var imgPhoneReceiver: UIImageView!
    
    @IBOutlet weak var imgArrow: UIImageView!
    
    @IBOutlet weak var lblNameUser: UILabel!
    @IBOutlet weak var lblNumberUser: UILabel!
    @IBOutlet weak var lblNameReceipt: UILabel!
    @IBOutlet weak var lblNumberReceipt: UILabel!
    
    @IBOutlet weak var lbPrice: UILabel!

    // MARK: Variables
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "PresentationCardCell")
        
        self.lblNameReceipt.text = UserDefaults.standard.string(forKey: PrefsKeys.PREFS_USER_NAME)
        self.lblNumberReceipt.text = UserDefaults.standard.string(forKey: PrefsKeys.PREFS_USER_CEL)?.formatText(format: "(##) #####-####")
    }
    
}
