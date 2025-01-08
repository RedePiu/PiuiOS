//
//  BusSeatsViewController.swift
//  MyQiwi
//
//  Created by Thyago on 16/08/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class BusSeatsViewController: ClickBusBaseViewController {

    enum Mode {

        case view
        case select
    }

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbNoContent: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cardProceed: UICardView!
    @IBOutlet weak var lbSeats: UILabel!
    @IBOutlet weak var lbSelected: UILabel!
    @IBOutlet weak var btnVoltar: UIButton!
    @IBOutlet weak var btnContinuar: UIButton!
    @IBOutlet weak var viewNoContent: UIView!
    @IBOutlet weak var viewLoading: UIActivityIndicatorView!
    
    //var arrSelectedIndex : [IndexPath: Bool] = [:]
    lazy var clickBusRN = ClickBusRN(delegate: self)
    
    var seats = [Seat]()
    var selectedSeats = [Seat]()

    var arraySelectedIndexes = [Int]()
    var arrSelectedIndex = [IndexPath]()
    var setEligibleIndexesForSelection = Set<Int>()
    var firstIndex = 0
    var lastIndex = -1
    let selectableItems = 5

    override func setupViewDidLoad() {

        self.setupUI()
        self.setupTexts()
        self.setupNib()

        self.cardProceed.isHidden = true
        self.btnContinuar.addTarget(self, action: #selector(buttonContinue), for: .touchUpInside)
        
        self.requestSeats()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func backStep() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func nextStep() {
        self.performSegue(withIdentifier: Constants.Segues.SHOW_TICKETS, sender: nil)
    }
}

extension BusSeatsViewController {
    
    @IBAction func onClickBack(_ sender: Any) {
        self.clickBackRoute()
    }
    
    @objc func deselectAll() {
        self.cardProceed.isHidden = true}

    @objc func buttonContinue() {
        
        let seatsRequest = self.clickBusRN.convertSeatToSeatRequest(seats: self.selectedSeats)
        
        if self.isAtSeatsGoingStep() {
            QiwiOrder.clickBusCharge?.seatsGo = seatsRequest
        } else {
            QiwiOrder.clickBusCharge?.seatsBack = seatsRequest
        }
        
        self.clickContinueRoute()
    }
}

extension BusSeatsViewController {
    
    func requestSeats() {
        self.viewLoading.isHidden = false
        self.collectionView.isHidden = true
        self.viewNoContent.isHidden = true
        
        let sessionId = self.isAtSeatsGoingStep() ? QiwiOrder.clickBusCharge!.sessionIdGo : QiwiOrder.clickBusCharge!.sessionIdBack
        let tripType = self.isAtSeatsGoingStep() ? 1 : 2
        let scheduleId = self.isAtSeatsGoingStep() ? QiwiOrder.clickBusCharge!.scheduleIdGo : QiwiOrder.clickBusCharge!.scheduleIdBack
        
        let request = ClickbusTripDetailRequest(sessionId: sessionId, tripType: tripType, scheduleId: scheduleId)
        self.clickBusRN.getClickbusTripDetail(request: request)
    }
}

extension BusSeatsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 10, height: 35)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.seats.count
    
        return self.seats.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SeatCollectionViewCell
        
        let index = indexPath.row
        let item = self.seats[index]

        let indexItem = indexPath.item

        cell.item = item
        cell.lbNumber.textColor = UIColor.white
        cell.imgSeat.image = UIImage(named: "ic_seat")!.withRenderingMode(.alwaysTemplate)
        

        if item.name != "@" {

            cell.contentView.isHidden = false
            cell.contentView.isUserInteractionEnabled = true
            cell.isOpaque = true
            cell.isMultipleTouchEnabled = true
            cell.isUserInteractionEnabled = true
        } else {

            cell.contentView.isHidden = true
            cell.contentView.isUserInteractionEnabled = false
            cell.isOpaque = false
            cell.isMultipleTouchEnabled = false
            cell.isUserInteractionEnabled = false
        }

        if self.selectedSeats.count >= 1 {
            self.cardProceed.isHidden = false
        } else if selectedSeats.count == 0 {
            self.cardProceed.isHidden = true
        }

        if self.selectedSeats.contains(item) {
            cell.imgSeat.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiYellow)
        } else {
            if item.isAvailable.isEmpty {
                cell.imgSeat.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey4)
            } else {
                cell.imgSeat.tintColor = UIColor(hexString: Constants.Colors.Hex.colorButtonGreen)
            }
        }

        if selectedSeats.count == 1 {
            self.lbSelected.text = "\(selectedSeats.count)" + " assento selecionado"
            self.lbSeats.text = selectedSeats[0].name
        } else if selectedSeats.count > 1 {
            self.lbSelected.text = "\(selectedSeats.count)" + " assentos selecionados"
            
            var seats = ""
            for i in 0..<selectedSeats.count {
                seats += selectedSeats[i].name
                
                if i < selectedSeats.count-1 {
                    seats += " - "
                }
            }
            self.lbSeats.text = seats
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let index = indexPath.row
        let item = self.seats[index]

        if item.name == "@" || item.isAvailable.isEmpty {
            return
        }

        //Verifica se já foi selecionado
        var indexFound = -1
        for i in 0..<selectedSeats.count {
            if item == selectedSeats[i] {
                indexFound = i
                break
            }
        }

        //Se encontrou - Já existe o item selecionado
        if indexFound > -1 {
            //print("Item já existe no clique. Removendo da lista: " + item.name)
            selectedSeats.remove(at: indexFound)
            self.collectionView.reloadItems(at: [indexPath])
            return
        }

        if self.selectedSeats.count >= 5 {
            return
        }

        self.selectedSeats.append(item)
        self.collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 0

        if arrSelectedIndex.contains(indexPath)  {
            arrSelectedIndex.remove(at: arrSelectedIndex.index(of: indexPath)!)
        }
    }
    
}

extension BusSeatsViewController {

    func updateArrays() {

       for i in self.firstIndex..<self.firstIndex+2 {
           if i < selectableItems && !self.arraySelectedIndexes.contains(i) {
               self.setEligibleIndexesForSelection.insert(i)}
       }

       for i in self.lastIndex-3..<self.lastIndex {
           if i >= 0 && !self.arraySelectedIndexes.contains(i) {
               self.setEligibleIndexesForSelection.insert(i)}
       }

        self.setEligibleIndexesForSelection.removeAll()
   }

    func setupNib() {
        self.collectionView.register(SeatCollectionViewCell.nib(), forCellWithReuseIdentifier: "Cell")
    }
}

extension BusSeatsViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {

        DispatchQueue.main.async {
            if param == Param.Contact.CLICKBUS_SEATS_AVAILABLE_RESPONSE {
                self.seats = result ? object as! [Seat] : [Seat]()
                
                self.viewLoading.isHidden = true
                
                self.collectionView.isHidden = !result
                self.viewNoContent.isHidden = result

                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                
                self.collectionView.reloadData()
            }
        }
    }
}

extension BusSeatsViewController: SetupUI {

    func setupUI() {

        Theme.default.backgroundCard(self)
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.orageButton(self.btnVoltar)
        Theme.default.greenButton(self.btnContinuar)
    }

    func setupTexts() {

        Util.setTextBarIn(self, title: "clickbus_title_nav".localized)
        
        if self.isAtSeatsGoingStep() {
            self.lbTitle.text = "clickbus_title_select_seat_go".localized.replacingOccurrences(of: "{local}", with: QiwiOrder.clickBusCharge!.cityDestiny!.name)
        } else {
            self.lbTitle.text = "clickbus_title_select_seat_returning".localized.replacingOccurrences(of: "{local}", with: QiwiOrder.clickBusCharge!.cityDeparture!.name)
        }
        
        self.lbNoContent.text = "clickbus_get_seats_error".localized
    }
}
