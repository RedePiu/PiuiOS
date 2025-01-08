//
//  DatePickerCompleteViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/03/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class DatePickerCompleteViewController: UIBaseViewController {
    
    // MARK: Ciclo de Vida
    @IBOutlet weak var picker: DayMonthYearPickerView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btContinue: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    
    // MARK: Variables
    var delegate: BaseDelegate?
    var currentDay: Int = 0
    var currentYear: Int = 0
    var currentMonth: Int = 0
    var isTimeInFuture = false
    var minimiumDate = Date()
    
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
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.onReceiveData(fromClass: DatePickerCompleteViewController.self, param: Param.Contact.CLICK_CANCEL, result: true, object: nil)
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        //let date = [self.picker.day, self.picker.month, self.picker.year]
        
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = self.picker.year
        dateComponents.month = self.picker.month
        dateComponents.day = self.picker.day

        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents) ?? Date()
        
        if QiwiOrder.isClickBus() && someDateTime.isBeforeDate(minimiumDate, granularity: .day) {
            let alert = "clickbus_alert_date_must_be_higher_than".localized.replacingOccurrences(of: "{date}", with: DateFormatterQiwi.formatDate(date: minimiumDate, format: DateFormatterQiwi.dateBrazil))
            
            Util.showAlertDefaultOK(self, message: alert)
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        self.delegate?.onReceiveData(fromClass: DatePickerCompleteViewController.self, param: Param.Contact.DATAPICKER_RESPONSE, result: true, object: someDateTime as AnyObject)
    }
}

extension DatePickerCompleteViewController {
    
    func setupAsTimeInFuture() {
        self.isTimeInFuture = true
        self.picker.setupTimeInFuture()
    }
}

extension DatePickerCompleteViewController: SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.greenButton(self.btContinue)
        Theme.default.redButton(self.btCancel)
        
        self.updateDate()
        
        self.picker.setValue(UIColor.init(hexString: Constants.Colors.Hex.colorGrey8), forKeyPath: "textColor")
    }
    
    func setupTexts() {
        
        //btnDontSee.addTarget(self, action: #selector(self.dontSeeAgain), for: .touchUpInside)
    }
    
    func updateDate() {
        let date = Date()
        self.picker.year = self.currentYear == 0 ? date.year : self.currentYear
        self.picker.month = self.currentMonth == 0 ? date.month : self.currentMonth
        self.picker.day = self.currentDay == 0 ? date.day : self.currentDay
    }
}


