//
//  NewCarViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 21/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class NewCarViewController: UIBaseViewController {
    @IBOutlet weak var iconCar: UIImageView!
    @IBOutlet weak var iconTruck: UIImageView!
    @IBOutlet weak var titleAdd: UILabel!
    @IBOutlet weak var btnContinuar: UIButton!
    @IBOutlet weak var plaqueLetter: MaterialField!
    @IBOutlet weak var plaqueNumber: MaterialField!
    @IBOutlet weak var cellPlaque: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupTextFields()
    }
}

extension NewCarViewController{
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.titleAdd)
        Theme.default.greenButton(self.btnContinuar)
    }
    func setupTexts() {
        Util.setTextBarIn(self, title: "parking_title_nav".localized)
        self.titleAdd.text = "parking_add_plate".localized
        self.btnContinuar.setTitle("continue_label".localized, for: .normal)
    }
    func setupTextFields() {
        //self.plaqueLetter.formatPattern = "@@@"
        //self.plaqueNumber.formatPattern = "####"
    }
}
