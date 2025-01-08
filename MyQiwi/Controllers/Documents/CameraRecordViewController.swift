//
//  CameraRecord.swift
//  MyQiwi
//
//  Created by Thyago on 19/07/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class CameraRecordViewController: UIBaseViewController {
    
    
    @IBOutlet weak var topDisclaimer: UIView!
    @IBOutlet weak var topDisclaimerText: UILabel!
    
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnSwitch: UIButton!
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
    }
}

extension CameraRecordViewController {
    
    func btnCapture() {
        
        btnRecord.layer.roundCorners(radius: 36)
        
    }
}

extension CameraRecordViewController: SetupUI {
    
    func setupUI() {
        
    }
    
    func setupTexts() {
        
    }
}
