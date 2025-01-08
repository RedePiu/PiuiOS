//
//  OfflineViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class OfflineViewController: UIBaseViewController {

    // MARK: IBActions
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    
    // MARK: Variables
    
    static var isPresent = false
    
    // MARK: Ciclo de vida
    
    init() {
        super.init(nibName: "OfflineViewController", bundle: Bundle.main)
        
        // Ativa flag
        OfflineViewController.isPresent = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Desativa flag
        OfflineViewController.isPresent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

// MARK: SetupUI

extension OfflineViewController: SetupUI {
    
    func setupUI() {
        Theme.Offline.textAsTitle(self.lbTitle)
        Theme.Offline.textAsDesc(self.lbDesc)
    }
    
    func setupTexts() {
        self.lbTitle.text = "no_network_title".localized
        self.lbDesc.text = "no_network_desc".localized
    }
}
