//
//  DatePickerViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class DatePickerViewController: UIBaseViewController {
    
    // MARK: Ciclo de Vida
    @IBOutlet weak var picker: MonthYearPickerView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var btContinue: UIButton!
    @IBOutlet weak var btCancel: UIButton!
    
    // MARK: Variables
    var delegate: BaseDelegate?
    var currentYear: Int?
    var currentMonth: Int?
    
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
    }
    
    @IBAction func onClickContinue(_ sender: Any) {
        let monthAndYear = String(format: "%02d/%d", self.picker.month, self.picker.year)
        
        self.dismiss(animated: true, completion: nil)
        self.delegate?.onReceiveData(fromClass: DatePickerViewController.self, param: Param.Contact.DATAPICKER_RESPONSE, result: true, object: monthAndYear as AnyObject)
    }
}
extension DatePickerViewController {

    func setupAsMonthYear() {
        
    }
}

extension DatePickerViewController: SetupUI {
    
    func setupUI() {
//        self.picker.onDateSelected = { (month: Int, year: Int) in
//            let monthAndYear = String(format: "%02d/%d", month, year)
//            self.dismiss(animated: true, completion: nil)
//            self.delegate?.onReceiveData(fromClass: DatePickerViewController.self, param: Param.Contact.DATAPICKER_RESPONSE, result: true, object: monthAndYear as AnyObject)
//        }
        
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.greenButton(self.btContinue)
        Theme.default.redButton(self.btCancel)
        
        var years = [Int]()
        for i in 2016..<2100 {
            years.append(i)
        }
        
        self.picker.years = years
        
        let date = Date()
        self.picker.year = self.currentYear ?? date.year
        self.picker.month = self.currentMonth ?? date.month
        
        self.picker.setValue(UIColor.init(hexString: Constants.Colors.Hex.colorGrey8), forKeyPath: "textColor")
    }
    
    func setupTexts() {
        
        //btnDontSee.addTarget(self, action: #selector(self.dontSeeAgain), for: .touchUpInside)
    }
}

