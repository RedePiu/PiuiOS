//
//  PromoCodePopup.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class PromoCodePopup: UIBaseViewController {
    
    @IBOutlet weak var btContinue: UIButton!
    
    // MARK: Ciclo de Vida
    
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
    
    @IBAction func onClickContinue(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PromoCodePopup: SetupUI {
    
    func setupUI() {
        Theme.default.greenButton(self.btContinue)
    }
    
    func setupTexts() {
        
        //btnDontSee.addTarget(self, action: #selector(self.dontSeeAgain), for: .touchUpInside)
    }
}
