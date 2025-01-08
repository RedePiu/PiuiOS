//
//  DateTravelViewController.swift
//  MyQiwi
//
//  Created by Thyago on 26/11/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit


class DateTravelViewController: ClickBusBaseViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewContinue: ViewContinue!
    
    let loc = Locale(identifier: "pt_BR")
    let dateFormatter = DateFormatter()
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        self.datePicker.locale = loc
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(clickBackRoute), for: .touchDown)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(onClickContinue), for: .touchDown)
    }
    
    override func backStep() {
        self.popPage()
    }
    
    override func nextStep() {
        self.performSegue(withIdentifier: Constants.Segues.COMPANIES_LIST, sender: nil)
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        
//        if self.isAtDepartureDateStep() {
//            QiwiOrder.clickBusCharge?.dateGo = self.getSelectedDate()
//        }
//        else if self.isAtReturningDateStep() {
//            QiwiOrder.clickBusCharge?.dateBack = self.getSelectedDate()
//        }
        
        self.clickContinueRoute()
    }
}

extension DateTravelViewController {
    
    func getSelectedDate() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: self.datePicker.date)
        self.view.endEditing(true)
        
        return date
    }
}

extension DateTravelViewController : SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
    }
    
    func setupTexts() {
        
        Util.setTextBarIn(self, title: "clickbus_title_nav".localized)
        self.lbTitle.text = "clickbus_title_date".localized
    }
}
