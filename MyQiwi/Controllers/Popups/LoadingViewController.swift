//
//  LoadingViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 29/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class LoadingViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Variables
    var message = "processing".localized
    
    // MARK: Init
    
    init() {
        super.init(nibName: "LoadingViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
    }
    
    override func setupViewWillAppear() {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoadingViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
    }
    
    func setupTexts() {
        self.lbTitle.text = self.message
    }
}
