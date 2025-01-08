//
//  ReceiptViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 09/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ReceiptViewController: UIBaseViewController {

    @IBOutlet weak var imgTelesena: UIImageView!
    @IBOutlet var textReceipt: UITextView!
    
    var isTelesena = false
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imgTelesena.isHidden = !isTelesena
        self.textReceipt.text = text
    }
}

extension ReceiptViewController {
    
    func setupUI() {
        Util.setTextBarIn(self, title: "order_receipt".localized)
    }
}
