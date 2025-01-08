//
//  UpdateNeededViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class UpdateNeededViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    // MARK: Variables
    
    // MARK: Ciclo de vida
    
    init() {
        super.init(nibName: "UpdateNeededViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: IBActions

extension UpdateNeededViewController {
    
    @IBAction func clickClose(sender: UIButton) {
        exit(0)
    }
    
    @IBAction func clickUpdate(sender: UIButton) {
        
        MainViewController.isUpdate = false
        Util.openAppleStore()
    }
}

// MARK: SetupUI

extension UpdateNeededViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.textAsMessage(self.lbDesc)
        Theme.default.blueButton(self.btnClose)
        Theme.default.greenButton(self.btnUpdate)
    }
    
    func setupTexts() {
        
        self.lbTitle.text = "update_needed_title".localized
        self.lbDesc.text = "update_needed_desc".localized
        
        self.btnUpdate.setTitle("update_needed_go_to_store_button".localized, for: .normal)
        self.btnClose.setTitle("update_needed_exit_button".localized, for: .normal)
    }
}
