//
//  TicketsDataViewController2.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/03/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class TicketsDataViewController2: ClickBusBaseViewController {
    
    // MARK : OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
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
    
    override func setupViewDidLoad() {

        self.setupUI()
        self.setupTexts()
        self.setupCollectionView()
        
        if self.isAtPassangersGoingStep() {
            self.seats = QiwiOrder.clickBusCharge!.seatsGo
        } else {
            self.seats = QiwiOrder.clickBusCharge!.seatsBack
        }
        
        for _ in 0..<seats.count {
            self.rowHeight.append(CGFloat(HEIGHT_DEFAULT))
            self.rowDropdownSelection.append("")
            self.rowSelectedPassanger.append(PassengerClickBus())
        }

        self.updatePassengers()
        
        self.viewContinue.btnBack.addTarget(self, action: #selector(onClickBack), for: .touchUpInside)
        self.viewContinue.btnContinue.addTarget(self, action: #selector(onClickContinue), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.isAtPassangersGoingStep() {
            if QiwiOrder.clickBusCharge!.reservedGo {
                self.dismissPage(nil)
            }
        }
        else if self.isAtPassangersReturningStep() {
            if QiwiOrder.clickBusCharge!.reservedBack {
                self.dismissPage(nil)
            }
        }
        else {
            self.dismissPage(nil)
        }
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
            QiwiOrder.clickBusCharge?.reservedGo = true
            
            if self.getCurrentStepIda() == .PAYMENT {
                ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
                self.performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
            } else {
                GenericDataInputViewController.inputType = .EMAIL
                self.performSegue(withIdentifier: Constants.Segues.GENERIC_INPUT, sender: nil)
            }
        }
        //IDA E VOLTA
        else {
            
            //Nesse momento a etapa já mudou para a proxima, que é a escolha do retorno
            if self.isAtSeatsReturningStep() {
                QiwiOrder.clickBusCharge?.reservedGo = true
                self.performSegue(withIdentifier: Constants.Segues.SEE_SEATS, sender: nil)
            } else {
                QiwiOrder.clickBusCharge?.reservedBack = true
                if self.getCurrentStepVolta() == .PAYMENT {
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

extension TicketsDataViewController2 {
    
    @IBAction func onClickArrowBack(_ sender: Any) {
        self.onClickBack()
    }
    
    @objc func onClickBack() {
//        Util.showLoading(self)
//        self.clickBusRN.cancelReserveSeat(request: ClickbusCancelReserveSeatRequest())
        self.clickBackRoute()
    }
    
    @objc func onClickContinue() {
        
        for i in 0..<self.seats.count {
            seats[i].passenger = self.rowSelectedPassanger[i]
        }
        
        var request: ClickbusReserveSeatRequest
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
            
            //Reserve
            request = ClickbusReserveSeatRequest(sessionId: QiwiOrder.clickBusCharge!.sessionIdGo, seats: self.clickBusRN.convertSeatsToSeatsRequest(seats: seats, isGo: true))
        } else {
            QiwiOrder.clickBusCharge?.seatsBack = seats
            QiwiOrder.clickBusCharge?.amountTicketBack = seats.count
            
            //Reserve
           request = ClickbusReserveSeatRequest(sessionId: QiwiOrder.clickBusCharge!.sessionIdBack, seats: self.clickBusRN.convertSeatsToSeatsRequest(seats: seats, isGo: false))
        }
        
        QiwiOrder.setTransitionAndValue(value: (QiwiOrder.clickBusCharge?.getTotalValue())!)
        Util.showAlertYesNo(self, message: "clickbus_alert_sure_want_to_continue".localized, completionOK: {
            self.doActionAfter(after: 0.3, completion: {
                Util.showLoading(self)
                self.clickBusRN.reserveSeat(request: request)
            })
        })
    }
}

extension TicketsDataViewController2 : BaseDelegate {

    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {

        DispatchQueue.main.async {
            if param == Param.Contact.UPDATE_PASSENGERS {
                let index = object as! Int
                self.rowSelectedPassanger[index] = PassengerClickBus()
                self.updatePassengers()
            }
            
            //Chamado sempre que o tamanho precisar ser atualizado
            else if param == Param.Contact.UPDATE_CELL_HEIGHT {
                self.updateCellHeight(index: object as! Int, inputOpened: result)
            }
            
            else if param == Param.Contact.USER_ADDED_TO_ARRAY || param == Param.Contact.USER_UPDATED_IN_ARRAY {
                let objs = object as! [AnyObject]
                let index = objs[0] as! Int
                let pass = objs[1] as! PassengerClickBus
                self.rowSelectedPassanger[index] = pass
                self.updatePassengers()
            }
            
            else if param == Param.Contact.USER_REMOVED_FROM_ARRAY {
                let doc = object as! String
                self.updateRemovedPassenger(document: doc)
                self.updatePassengers()
            }
        }
        
        if fromClass == ClickBusRN.self {
            if param == Param.Contact.CLICKBUS_RESERVE_SEAT_RESPONSE {
                self.dismissPageAfter(after: 0.3)
                
                self.doActionAfter(after: 0.7, completion: {
                    if result {
                        self.clickContinueRoute()
                    } else {
                        Util.showAlertDefaultOK(self, message: "clickbus_alert_reserv_seat_failed".localized)
                    }
                })
            }
        }
    }
}

extension TicketsDataViewController2 {
    
    func updateCellHeight(index: Int, inputOpened: Bool) {
        self.rowHeight[index] = !inputOpened ? CGFloat(self.HEIGHT_DEFAULT) : CGFloat(self.HEIGHT_INPUT)
        //self.collectionView.reloadData()
        self.collectionView.performBatchUpdates(nil, completion: nil)
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
        self.collectionView.reloadData()
        
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
    
    /**
        retorna o index para ser adicionado ao dropdown ou -1 se não houver
     */
    func updateRemovedPassenger(document: String) {
        
        if !document.isEmpty {
            for i in 0..<self.passengers.count {
                if document == self.passengers[i].document {
                    self.passengers[i] = PassengerClickBus()
                }
            }
        }
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

// Data Collection
extension TicketsDataViewController2: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.seats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TicketCell2

        let index = indexPath.row
        let item = self.seats[index]
        cell.item = item

        cell.sender = self
        cell.delegate = self
        cell.setIndex(index: index)
        cell.lbSeatNumber.text = item.seatName
        
        //select row
        let selectedIndex = self.findPassangerIndex(row: index)
        if selectedIndex > -1 {
            cell.dropdown.text = self.passengersString[selectedIndex]
            cell.dropdown.selectedIndex = selectedIndex
            cell.selectedPassanger = self.rowSelectedPassanger[selectedIndex]
        } else {
            cell.dropdown.text = ""
            cell.dropdown.selectedIndex = nil
            cell.selectedPassanger = PassengerClickBus()
        }
        
        cell.viewInput.isHidden = cell.dropdown.selectedIndex == nil || cell.dropdown.selectedIndex != self.passengersString.count - 1
        cell.viewEdit.isHidden = cell.dropdown.selectedIndex == nil || cell.dropdown.selectedIndex == self.passengersString.count - 1
        
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
            //self.collectionView.reloadData()
            self.collectionView.performBatchUpdates(nil, completion: nil)
            
            if self.isAllSeatsSelected() {
                self.viewContinue.showBackAndContinueButtons()
            } else {
                self.viewContinue.showOnlyBackButton()
            }
        }

        cell.ddDocType.optionArray = self.documentTypes
        cell.ddDocType.didSelect{(selectedText, dropdownIndex, id) in
            if selectedText == "CPF" {
                cell.txtDocument.formatPattern = "###.###.###-##"
            } else {
                cell.txtDocument.formatPattern = ""
            }
        }

        return cell
    }
}

// MARK: Layout Collection
extension TicketsDataViewController2: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Layout custom
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 5
            flowLayout.minimumInteritemSpacing = 5
        }
        
        let size = CGSize(width: self.collectionView.frame.width, height: self.rowHeight[indexPath.row])
        return size
    }
}

extension TicketsDataViewController2: SetupUI {
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
    
    func setupCollectionView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //  Cell custom
        self.collectionView.register(TicketCell2.nib(), forCellWithReuseIdentifier: "Cell")
        self.collectionView.layer.masksToBounds = true
    }
}
