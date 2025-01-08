//
//  ParkingCadsViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 01/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ParkingCadsViewController: UIBaseViewController {

    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var valueCad: UILabel!
    @IBOutlet weak var btnAdd: UIImage!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var lbValueField: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var value : Int = 1
    var cad : Int = 5
    let valueField : Int = 1
    
    @IBAction func btnIncrease(_ sender: Any) {
        self.goIncrease()
    }
    @IBAction func btnDecrease(_ sender: Any) {
        self.goDecrease()
    }
    
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }

}

extension ParkingCadsViewController {
    
    func goIncrease() {
        if self.value == Int(1) {
            self.value = self.value + 1
            self.cad = self.cad + 5
            self.lbValueField.text = String(self.value)
            self.valueCad.text = String(self.cad)
        }
    }
    func goDecrease() {
        if self.value == Int(2) {
            self.value = self.value - 1
            self.cad = self.cad - 5
            self.lbValueField.text = String(self.value)
            self.valueCad.text = String(self.cad)
        }
    }
    func updatePrice() {
        
        self.lbValueField.text = String(self.value)
    }
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lblMain)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "parking_title_nav".localized)
        self.lblMain.text = "parking_cad_quantity".localized
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    }
}
