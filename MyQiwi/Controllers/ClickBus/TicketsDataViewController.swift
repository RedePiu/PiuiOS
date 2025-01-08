//
//  TicketsDataViewController.swift
//  MyQiwi
//
//  Created by Thyago on 06/09/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class TicketsDataViewController: ClickBusBaseViewController, UITableViewDelegate {

    // MARK : OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewContinue: ViewContinue!
    //@IBOutlet weak var heightTable: NSLayoutConstraint!
    
    // MARK : CONSTANTS
    let HEIGHT_DEFAULT = 80
    let HEIGHT_INPUT = 260

    // MARK : VARIABLES
    lazy var clickBusRN = ClickBusRN(delegate: self)
    var seats = [ClickBusSeat]()
    var passengers = [PassengerClickBus]()
    var passengersString = [String]()
    var rowHeight = [CGFloat]()
    var rowDropdownSelection = [String]()
    var rowSelectedPassanger = [PassengerClickBus]()
    var documentTypes = ClickBusRN.getPassangerDocumentList()
    //let heightRow = CGFloat(80)

    override func setupViewDidLoad() {

        self.setupUI()
        self.setupTexts()
        
        self.seats = QiwiOrder.clickBusCharge!.seatsGo
        
        for _ in 0..<seats.count {
            self.rowHeight.append(CGFloat(HEIGHT_DEFAULT))
            self.rowDropdownSelection.append("")
            self.rowSelectedPassanger.append(PassengerClickBus())
        }

        self.setupNib()
        self.tableViewSettings()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.updatePassengers()
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(onClickContinue), for: .touchUpInside)
    }

    func setupHeightTable() {
//        self.heightTable.constant = self.tableView.contentSize.height + 20
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    override func backStep() {
        self.popPage()
    }
    
    override func nextStep() {
        
        if QiwiOrder.isClickBusOnlyIda() {
            
            if self.getCurrentStepIda() == .PAYMENT {
                ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
                self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
            } else {
                GenericDataInputViewController.inputType = .EMAIL
                self.performSegue(withIdentifier: Constants.Segues.GENERIC_INPUT, sender: nil)
            }
        } else {
            //Nesse momento a etapa já mudou para a proxima, que é a escolha do retorno
            if self.isAtSeatsReturningStep() {
                self.performSegue(withIdentifier: Constants.Segues.SEE_SEATS, sender: nil)
            } else {
                if self.getCurrentStepIda() == .PAYMENT {
                    ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
                    self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
                } else {
                    GenericDataInputViewController.inputType = .EMAIL
                    self.performSegue(withIdentifier: Constants.Segues.GENERIC_INPUT, sender: nil)
                }
            }
        }
    }
}

extension TicketsDataViewController {
    
    @objc func onClickBack() {
        self.clickBackRoute()
    }
    
    @objc func onClickContinue() {
        
        for i in 0..<self.seats.count {
            seats[i].passenger = self.rowSelectedPassanger[i]
        }
        
        if self.isAtPassangersGoingStep() {
            QiwiOrder.clickBusCharge?.seatsGo = seats
            QiwiOrder.clickBusCharge?.amountTicketGo = seats.count
            
            let passanger = QiwiOrder.clickBusCharge?.seatsGo[0].passenger
            QiwiOrder.checkoutBody.requestClickbus?.buyerFirstName = passanger!.getFirstName()
            QiwiOrder.checkoutBody.requestClickbus?.buyerLastName = passanger!.getLastName()
            QiwiOrder.checkoutBody.requestClickbus?.buyerDocument = passanger!.document
            
            QiwiOrder.checkoutBody.requestClickbus?.sessionId = QiwiOrder.clickBusCharge!.sessionIdGo
            QiwiOrder.checkoutBody.requestClickbus?.buyerBirthday = "1985-02-24"
            QiwiOrder.checkoutBody.requestClickbus?.locale = "pt_BR"
            QiwiOrder.checkoutBody.requestClickbus?.buyerGender = "F"
            
            if ApplicationRN.isQiwiBrasil() {
                QiwiOrder.checkoutBody.requestClickbus?.buyerEmail = ""
                QiwiOrder.checkoutBody.requestClickbus?.buyerPhone = ""
            }
        } else {
            QiwiOrder.clickBusCharge?.seatsBack = seats
            QiwiOrder.clickBusCharge?.amountTicketBack = seats.count
        }
        
        QiwiOrder.setTransitionAndValue(value: (QiwiOrder.clickBusCharge?.getTotalValue())!)
        self.clickContinueRoute()
    }
}

extension TicketsDataViewController {

    func tableViewSettings() {

        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.frame = self.view.frame
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    func setupNib() {
        self.tableView.register(TicketCell.nib(), forCellReuseIdentifier: "Cell")
    }
}

extension TicketsDataViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seats.count
    }

    func updateRow(indexPath: IndexPath) {

        let cell = self.tableView.cellForRow(at: indexPath)

//        self.tableView.beginUpdates()
//        self.tableView.reloadRows(at: [(NSIndexPath(row: row, section: 0) as IndexPath)], with: UITableViewRowAnimation.fade)
//        self.tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! TicketCell
        let index = indexPath.row
        let item = self.seats[index]
        cell.item = item

        cell.sender = self
        cell.delegate = self
        cell.setIndex(index: index)
        cell.lbSeatNumber.text = item.seatName
    
 //       cell.cvCard.frame.size.width = self.tableView.frame.size.width
        //cell.cvCard.frame = CGRect(x:0, y: 0, width:self.tableView.frame.size.width, height: self.rowHeight[index])
        
        self.setupHeightTable()

        //select row
        let selectedIndex = self.findPassangerIndex(row: index)
        if selectedIndex > -1 {
            cell.dropdown.text = self.passengersString[selectedIndex]
            cell.dropdown.selectedIndex = selectedIndex
        } else {
            cell.dropdown.text = ""
        }
        cell.dropdown.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width-120, height: 50)
        
        cell.viewInput.isHidden = cell.dropdown.selectedIndex != self.passengersString.count - 1
        cell.viewEdit.isHidden = cell.dropdown.selectedIndex != self.passengersString.count - 1
        
        // The list of array to display. Can be changed dynamically
        cell.dropdown.optionArray = self.passengersString
        cell.dropdown.didSelect{(selectedText, dropdownIndex, id) in
            cell.viewEdit.isHidden = dropdownIndex == self.passengersString.count - 1
            self.rowDropdownSelection[index] = self.passengersString[dropdownIndex]
            
            //Verificar se é parar abrir edição ou não
            if dropdownIndex == self.passengersString.count - 1 {
                cell.openInputForAdd()
                cell.selectedPassanger = PassengerClickBus()
                self.rowSelectedPassanger[index] = PassengerClickBus()
            } else {
                cell.viewInput.isHidden = true
                cell.selectedPassanger = self.passengers[dropdownIndex]
                self.rowSelectedPassanger[index] = self.passengers[dropdownIndex]
            }
            
            //update height
            self.rowHeight[index] = cell.viewInput.isHidden ? CGFloat(self.HEIGHT_DEFAULT) : CGFloat(self.HEIGHT_INPUT)
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
            if self.isAllSeatsSelected() {
                self.viewContinue.showBackAndContinueButtons()
            } else {
                self.viewContinue.showOnlyBackButton()
            }
            
            cell.dropdown.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width-120, height: 50)
        }

        cell.ddDocType.optionArray = self.documentTypes
        cell.ddDocType.didSelect{(selectedText, dropdownIndex, id) in
            if selectedText == "CPF" {
                cell.txtDocument.formatPattern = "###.###.###-##"
            } else {
                cell.txtDocument.formatPattern = ""
            }
        }

        //cell.btnInsert.addTarget(self, action: #selector(showDataView), for: .touchUpInside)

        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight[indexPath.row]
        //return  CGFloat(300)
        //return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(340)
    }
}

extension TicketsDataViewController : BaseDelegate {

    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {

        DispatchQueue.main.async {
            if param == Param.Contact.UPDATE_PASSENGERS {
                let index = object as! Int
                self.rowSelectedPassanger[index] = PassengerClickBus()
                self.updatePassengers()
            }
            
            //Chamado sempre que o tamanho precisar ser atualizado
            if param == Param.Contact.UPDATE_CELL_HEIGHT {
                self.updateCellHeight(index: object as! Int, inputOpened: result)
            }
            
            if param == Param.Contact.USER_ADDED_TO_ARRAY {
                let objs = object as! [AnyObject]
                let index = objs[0] as! Int
                let pass = objs[1] as! PassengerClickBus
                self.rowSelectedPassanger[index] = pass
                self.updatePassengers()
            }
        }
    }
}

extension TicketsDataViewController {
    
    func updateCellHeight(index: Int, inputOpened: Bool) {
        self.rowHeight[index] = !inputOpened ? CGFloat(self.HEIGHT_DEFAULT) : CGFloat(self.HEIGHT_INPUT)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }

    func updatePassengers() {
        self.passengers = self.clickBusRN.getPassengers()
        self.passengersString.removeAll()

        for pass in self.passengers {
            self.passengersString.append(pass.name)
        }
        
        self.rowHeight.removeAll()
        for _ in 0..<seats.count {
            self.rowHeight.append(CGFloat(self.HEIGHT_DEFAULT))
        }

        self.passengersString.append("Novo passageiro")
        self.tableView.reloadData()
        
        if self.isAllSeatsSelected() {
            self.viewContinue.showBackAndContinueButtons()
        } else {
            self.viewContinue.showOnlyBackButton()
        }
    }
    
    /**
        retorna o index para ser adicionado ao dropdown ou -1 se não houver
     */
    func findPassangerIndex(row: Int) -> Int {
        let pass = self.rowSelectedPassanger[row]
        
        if !pass.name.isEmpty {
            for i in 0..<self.passengers.count {
                if pass.document == self.passengers[i].document {
                    return i
                }
            }
        }
        
        return -1
    }
    
    func isAllSeatsSelected() -> Bool {
        
        for seat in self.rowSelectedPassanger {
            if seat.document.isEmpty {
                return false
            }
        }
        
        return true
    }
}

extension TicketsDataViewController : SetupUI {

    func setupUI() {

        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        //Theme.default.greenButton(self.btnDataInsert)
        
        self.viewContinue.showOnlyBackButton()
    }

    func setupTexts() {
        Util.setTextBarIn(self, title: "clickbus_title_nav".localized)
        
        if self.isAtPassangersGoingStep() {
            self.lbTitle.text = "clickbus_title_users_go".localized.replacingOccurrences(of: "{local}", with: QiwiOrder.clickBusCharge!.cityDestiny!.name)
        } else {
            self.lbTitle.text = "clickbus_title_users_returning".localized.replacingOccurrences(of: "{local}", with: QiwiOrder.clickBusCharge!.cityDeparture!.name)
        }
    }
}
