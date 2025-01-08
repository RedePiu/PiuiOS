//
//  ListCompaniesViewController.swift
//  MyQiwi
//
//  Created by Thyago on 13/08/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ListCompaniesViewController: ClickBusBaseViewController {

    @IBOutlet weak var lbDestinyTitle: UILabel!
    @IBOutlet weak var lbGoingTitle: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var lbNoContentText: UILabel!
    @IBOutlet weak var viewList: UIView!
    @IBOutlet weak var viewLoading: UIActivityIndicatorView!
    
    // MARK : VARIABLES
    lazy var clickBusRN = ClickBusRN(delegate: self)
    var trips = [ClickbusScheduleResponse]()
    let locationVC = LocalizationChooseViewContoller()
    var selectedDate = Date()
    var pickerOpened = false

    override func setupViewDidLoad() {

        self.setupUI()
        self.setupTexts()
        self.setupNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickDate(_:)))
        self.lbDate.addGestureRecognizer(tap)

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !self.isAtPassageSelectionGoingStep() && !self.isAtPassageSelectionReturningStep() {
            self.dismissPage(nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.pickerOpened {
            self.pickerOpened = true
            self.openPicker()
        }
    }
    
    func showLoading() {
        self.viewList.isHidden = true
        self.viewEmpty.isHidden = true
        self.viewLoading.isHidden = false
    }

    func showList() {
        self.tableView.reloadData()
        
        self.viewLoading.isHidden = true
        self.viewEmpty.isHidden = true
        self.viewList.isHidden = false
    }
    
    func showNoContent() {
        self.viewLoading.isHidden = true
        self.viewList.isHidden = true
        self.viewEmpty.isHidden = false
    }

    func setupNib() {
        self.tableView.register(BusCompaniesCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    override func backStep() {
        self.popPage()
    }
    
    override func nextStep() {
        
        self.performSegue(withIdentifier: Constants.Segues.SEE_SEATS, sender: nil)
    }
    
    override func realodData() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        
        if self.isAtPassageSelectionReturningStep() {
            self.selectedDate = QiwiOrder.clickBusCharge!.dateObjGo
            self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate)!
        }
        
//        self.requestScheduleList()
        self.pickerOpened = true
        self.openPicker()
    }
}

extension ListCompaniesViewController {
    
    @IBAction func onClickDateBackward(_ sender: Any) {
        self.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: self.selectedDate) ?? Date()
        
        self.requestScheduleList()
    }
    
    @IBAction func onClickDateForward(_ sender: Any) {
        self.selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: self.selectedDate) ?? Date()
        
        self.requestScheduleList()
    }
    
    // function which is triggered when handleTap is called
    @objc func onClickDate(_ sender: UITapGestureRecognizer) {
        self.openPicker()
    }
    
    func openPicker() {
        
        Util.showController(DatePickerCompleteViewController.self, sender: self, completion: { controller in
            controller.delegate = self
            
            let date = self.isAtPassageSelectionReturningStep() ? QiwiOrder.clickBusCharge!.dateObjGo : self.selectedDate
            controller.currentDay = date.day
            controller.currentMonth = date.month
            controller.currentYear = date.year
            
            if self.isAtPassageSelectionReturningStep() {
                controller.minimiumDate = QiwiOrder.clickBusCharge!.dateObjGo
            }
            
            controller.setupAsTimeInFuture()
            controller.lbTitle.text = self.isAtPassageSelectionGoingStep() ? "clickbus_date_title_go".localized : "clickbus_date_title_return".localized
            controller.updateDate()
        })
    }
}

extension ListCompaniesViewController {
    
    func requestScheduleList() {
        self.showLoading()
        
        //Se for hoje, esconde o botão voltar
        if self.isAtPassageSelectionGoingStep() {
            self.btnBackward.isHidden = self.selectedDate.isToday
        } else {
            self.btnBackward.isHidden = self.selectedDate.isBeforeDate(QiwiOrder.clickBusCharge!.dateObjGo, orEqual: true, granularity: .day)
        }
        
        let date = DateFormatterQiwi.formatDate(date: self.selectedDate, format: "yyyy-MM-dd")
        let dateLabel = DateFormatterQiwi.formatDate(date: self.selectedDate, format: "d MMMM yyyy\nEEEE")
        self.lbDate.text = dateLabel
        
        var request: ClickBusScheduleRequest
        
        if self.isAtPassageSelectionGoingStep() {
            QiwiOrder.clickBusCharge!.dateGo = date
            
            request = ClickBusScheduleRequest(idSession: 0, from: (QiwiOrder.clickBusCharge?.cityDeparture!.slug)!, to: (QiwiOrder.clickBusCharge?.cityDestiny!.slug)!, Date: date, tripType: ClickBusBaseViewController.TYPE_GO)
        }
        else {
            QiwiOrder.clickBusCharge!.dateGo = date
            
            request = ClickBusScheduleRequest(idSession: QiwiOrder.clickBusCharge!.sessionIdGo, from: (QiwiOrder.clickBusCharge?.cityDestiny!.slug)!, to: (QiwiOrder.clickBusCharge?.cityDeparture!.slug)!, Date: date, tripType: ClickBusBaseViewController.TYPE_BACK)
        }
        
        self.clickBusRN.getClickBusSchedule(request: request)
    }
}

extension ListCompaniesViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
     
        DispatchQueue.main.async {
            if fromClass == ClickBusRN.self {
                if param == Param.Contact.CLICKBUS_SCHEDULE_RESPONSE {
                    
                    if result {
                        self.trips = object as! [ClickbusScheduleResponse]
                        
                        if !self.trips.isEmpty {
                            self.showList()
                            return
                        }
                    }
                    //Se deu falha ou está vazia, mostra que não ha conteudo
                    self.showNoContent()
                }
            }
            
            if fromClass == DatePickerCompleteViewController.self {
                if param == Param.Contact.DATAPICKER_RESPONSE {
                    self.selectedDate = object as! Date
                    self.requestScheduleList()
                }
                else if param == Param.Contact.CLICK_CANCEL {
                    if self.trips.isEmpty {
                        self.doActionAfter(after: 0.6, completion: {
                            self.clickBackRoute()
                        })
                    }
                }
            }
        }
    }
}

extension ListCompaniesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! BusCompaniesCell
        //
        let index = indexPath.row
        let item = self.trips[index]

        cell.item = item
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension //CGFloat(160)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let item = self.trips[indexPath.row]
        
        if self.isAtPassageSelectionGoingStep() {
            QiwiOrder.clickBusCharge?.dateObjGo = self.selectedDate
            QiwiOrder.clickBusCharge?.scheduleIdGo = item.scheduleId
            QiwiOrder.clickBusCharge?.sessionIdGo = item.sessionId
            QiwiOrder.clickBusCharge?.ticketPriceGo = item.price
        } else {
            QiwiOrder.clickBusCharge?.dateObjReturning = self.selectedDate
            QiwiOrder.clickBusCharge?.scheduleIdBack = item.scheduleId
            QiwiOrder.clickBusCharge?.sessionIdBack = item.sessionId
            QiwiOrder.clickBusCharge?.ticketPriceBack = item.price
        }
    
        self.clickContinueRoute()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        viewFooter.backgroundColor = UIColor.clear
        return viewFooter
    }
}

extension ListCompaniesViewController {

}

extension ListCompaniesViewController : SetupUI {

    func setupUI() {

        Util.setTextBarIn(self, title: "clickbus_title_nav".localized)
        Theme.default.backgroundCard(self)
        self.viewHeader.layer.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiBlue).cgColor
        self.lbNoContentText.setupMessageMedium()
    }

    func setupTexts() {

        //self.lbTitleDestination.text = "clickbus_going_to".localized
        
        if self.isAtPassageSelectionGoingStep() {
            self.lbGoingTitle.text = "clickbus_going_to".localized
            self.lbDestinyTitle.text = QiwiOrder.clickBusCharge?.cityDestiny?.name ?? ""
        }
        else if self.isAtPassageSelectionReturningStep() {
            self.lbGoingTitle.text = "clickbus_returning_to".localized
            self.lbDestinyTitle.text = QiwiOrder.clickBusCharge?.cityDeparture?.name ?? ""
        }
        
        self.lbNoContentText.text = "clickbus_no_trips_available".localized
    }
}
