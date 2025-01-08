//
//  BlueZoneViewController.swift
//  MyQiwi
//
//  Created by Douglas on 15/05/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class BlueZoneViewController: UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var slcTitle: UILabel!
    @IBOutlet weak var lblConvert: UILabel!
    @IBOutlet weak var lblSaldo: UILabel!
    @IBOutlet weak var btnExtract: UIButton!
    @IBOutlet weak var btnComprar: UIButton!
    @IBOutlet weak var btnOutro: UIButton!
    @IBOutlet weak var descTouch: UILabel!
    
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BlueZoneViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

// MARK: Modal Delegate
extension BlueZoneViewController: DismisModalDelegate {
    
    func modalDismiss() {
        self.dismiss(animated: false)
    }
}


// MARK: SetupUI
extension BlueZoneViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsListTitle(self.slcTitle)
        Theme.default.textAsListTitle(self.lblSaldo)
        Theme.default.blueButton(self.btnExtract)
        Theme.default.blueButton(self.btnOutro)
        Theme.default.greenButton(self.btnComprar)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "parking_title_nav".localized)
        self.lbTitle.text = "parking_buy_cards".localized
        self.slcTitle.text = "parking_select_or_add_car".localized
        self.descTouch.text = "parking_touch_to_edit".localized
        self.lblConvert.text = "parking_touch_to_convert".localized
        self.btnComprar.setTitle("parking_buttons_buy_cards".localized, for: .normal)
        self.btnExtract.setTitle("parking_see_extract".localized, for: .normal)
        self.btnOutro.setTitle("parking_toolbar_add_vehicle".localized, for: .normal)
    }
}
