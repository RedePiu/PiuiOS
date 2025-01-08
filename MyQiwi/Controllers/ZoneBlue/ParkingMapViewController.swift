//
//  ParkingMapViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 26/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ParkingMapViewController: UIBaseViewController {

    @IBOutlet weak var btnVoltar: UIButton!
    @IBOutlet weak var btnOutrarua: UIButton!
    @IBOutlet weak var titleSelect: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
}

extension ParkingMapViewController{
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnVoltar)
        Theme.default.blueButton(self.btnOutrarua)
        Theme.default.textAsListTitle(self.titleSelect)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "parking_title_nav".localized)
        self.btnVoltar.setTitle("back".localized, for: .normal)
        self.btnOutrarua.setTitle("parking_button_active".localized, for: .normal)
        self.titleSelect.text = "parking_select_address".localized
    }
}
