//
//  DayMonthYearPickerView.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/03/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DayMonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var days: [Int]!
    var months: [String]!
    var years: [Int]!
    
    var day = Calendar.current.component(.day, from: Date()) {
        didSet {
            selectRow(day-1, inComponent: 0, animated: false)
            self.modifyDayIfDoesnExist()
        }
    }
    
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month-1, inComponent: 1, animated: false)
            self.modifyDayIfDoesnExist()
        }
    }
    
    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            selectRow(years.index(of: year)!, inComponent: 2, animated: true)
            self.modifyDayIfDoesnExist()
        }
    }
    
    var onDateSelected: ((_ day: Int, _ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func modifyDayIfDoesnExist() {
        let dateComponents = DateComponents(year: self.year, month: self.month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        if self.day  > numDays {
            selectRow(numDays-1, inComponent: 0, animated: false)
        }
    }
    
    func setupTimeInFuture() {
        let initialYear = Calendar.current.component(.year, from: Date())
        
        var years: [Int] = []
        for i in initialYear..<2100 {
            years.append(i)
        }
        self.years = years
        self.reloadComponent(2)
        self.selectRow(years.index(of: year)!, inComponent: 2, animated: false)
    }
    
    func commonSetup() {
        // population days
        var days: [Int] = []
        if days.count == 0 {
            for i in 1...31 {
                days.append(i)
            }
        }
        self.days = days
        
        // population years
        var years: [Int] = []
        if years.count == 0 {
            for i in 1910..<2100 {
                years.append(i)
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        self.delegate = self
        self.dataSource = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
        self.selectRow(currentMonth - 1, inComponent: 1, animated: false)
    }
    
    // Mark: UIPicker Delegate / Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(days[row])"
        case 1:
            return months[row]
        case 2:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return days.count
        case 1:
            return months.count
        case 2:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let day = self.selectedRow(inComponent: 0)+1
        let month = self.selectedRow(inComponent: 1)+1
        let year = self.years[self.selectedRow(inComponent: 2)]
        if let block = onDateSelected {
            block(day, month, year)
        }
        
        self.day = day
        self.month = month
        self.year = year
    }
    
}
