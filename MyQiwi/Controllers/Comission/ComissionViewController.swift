//
//  ComissionViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ComissionViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbText_1: UILabel!
    @IBOutlet weak var lbText_2: UILabel!
    @IBOutlet weak var lbText_3: UILabel!
    @IBOutlet weak var lbText_4: UILabel!
    @IBOutlet weak var lbSeeTable: UILabel!
    
    // MARK: Properites
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
        self.hideAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: Methods custom

extension ComissionViewController {
    
    @objc func onClickCommission() {
        Util.showController(CommissionTaxViewController.self, sender: self)
    }
    
    func hideAll() {
        self.tableView.superview?.isHidden = true
    }
}

extension ComissionViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
    }
}

// MARK: SetupUI

extension ComissionViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        Theme.Comission.textAsSubtitle(self.lbDesc)
        Theme.Comission.textAsSubtitle(self.lbText_1)
        Theme.Comission.textAsSubtitle(self.lbText_2)
        Theme.Comission.textAsSubtitle(self.lbText_3)
        Theme.Comission.textAsSubtitle(self.lbText_4)
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClickCommission))
        lbSeeTable.isUserInteractionEnabled = true
        lbSeeTable.addGestureRecognizer(tap)
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "commissioning_title".localized)
        self.lbDesc.text = "commissioning_desc".localized
    }
}
