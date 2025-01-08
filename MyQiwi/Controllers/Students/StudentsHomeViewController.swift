//
//  StudentsHomeViewController.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 25/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import UIKit

class StudentsHomeViewController : UIBaseViewController {
    
    @IBOutlet weak var lbWelcome: UILabel!
    @IBOutlet weak var lbStudent: UILabel!
    @IBOutlet weak var lbWhatGoingToDo: UILabel!
    @IBOutlet weak var lbNewFormTitle: UILabel!
    @IBOutlet weak var lbNewFormDesc: UILabel!
    @IBOutlet weak var lbFormStatusTitle: UILabel!
    @IBOutlet weak var lbFormStatusDesc: UILabel!
    
    override func setupViewDidLoad() {

        self.setupUI()
        self.setupTexts()
    }
}

extension StudentsHomeViewController {
    
    @IBAction func onClickNewForm(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.STUDENT_FORM, sender: nil)
    }
    
    @IBAction func onClickFormStatus(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.STUDENT_FORM_STATUS, sender: nil)
    }
}

extension StudentsHomeViewController {
    
}

extension StudentsHomeViewController : SetupUI {
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        
        self.lbWelcome.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbStudent.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        
        self.lbWhatGoingToDo.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
    }
    
    func setupTexts() {
        
        Util.setTextBarIn(self, title: "transport_students_toolbar".localized)
        
        lbWelcome.text = "transport_students_welcome".localized
        lbStudent.text = "transport_students_student".localized
        lbWhatGoingToDo.text = "transport_students_select_options".localized
        
        lbNewFormTitle.text = "transport_students_send_new_form".localized
        lbNewFormDesc.text = "transport_students_send_new_form_desc".localized
        
        lbFormStatusTitle.text = "transport_students_verify_situation".localized
        lbFormStatusDesc.text = "transport_students_verify_situation_desc".localized
    }
}

