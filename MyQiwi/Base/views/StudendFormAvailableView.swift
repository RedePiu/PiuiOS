//
//  StudendFormAvailableView.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 06/09/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class StudentFormAvailableView : LoadBaseView {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var btnSee: UIButton!
    
    override func initCoder() {
        self.loadNib(name: "StudentFormAvailableView")
        self.setupView()
    }
}

extension StudentFormAvailableView {
    
}

extension StudentFormAvailableView {
    
    func setupView() {
        self.lbTitle.text = "transport_students_ei_students".localized
        self.lbDesc.text = "transport_students_form_available".localized
    }
}
