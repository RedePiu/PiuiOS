//
//  BuyBlueZoneViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 21/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class BuyBlueZoneViewController: UIBaseViewController {

    @IBOutlet weak var lblChoose: UILabel!
    @IBOutlet weak var descCads: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnQuinze: UIButton!
    @IBOutlet weak var btnDez: UIButton!
    @IBOutlet weak var btnCinco: UIButton!
    @IBOutlet weak var priceNumber: UILabel?
    
    var valor : Int = 0
    
    
    @IBAction func maisCinco(_ sender: Any) {
        self.incrementCinco()
    }
    @IBAction func maisDez(_ sender: Any) {
        self.incrementDez()
    }
    @IBAction func maisQuinze(_ sender: Any) {
        self.incrementQuinze()
    }
    @IBAction func clearCalc(_ sender: Any) {
        self.clear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BuyBlueZoneViewController{
    
    func incrementCinco() {
        self.valor = self.valor + 5
        self.priceNumber?.text = String(self.valor)
    }
    func incrementDez() {
        self.valor = self.valor + 10
        self.priceNumber?.text = String(self.valor)
    }
    func incrementQuinze() {
        self.valor = self.valor + 15
        self.priceNumber?.text = String(self.valor)
    }
    func clear() {
        self.valor = 0
        self.priceNumber?.text = String(self.valor)
    }
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnBack)
        Theme.default.greenButton(self.btnContinue)
        Theme.default.textAsListTitle(self.lblChoose)
        Theme.default.textAsMessage(self.descCads)
        Theme.default.roundedBlueButton(self.btnQuinze)
        Theme.default.roundedBlueButton(self.btnDez)
        Theme.default.roundedBlueButton(self.btnCinco)
    }
    func setupTexts() {
        Util.setTextBarIn(self, title: "parking_title_nav".localized)
        self.lblChoose.text = "parking_buy_cards_values_desc".localized
        self.descCads.text = "parking_description_cads".localized
        self.btnBack.setTitle("back".localized, for: .normal)
        self.btnContinue.setTitle("continue_label".localized, for: .normal)
    }
}
