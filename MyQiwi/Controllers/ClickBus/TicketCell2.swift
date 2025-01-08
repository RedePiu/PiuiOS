//
//  TicketCell2.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/03/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit
import iOSDropDown

class TicketCell2: UICollectionViewCell {

    @IBOutlet weak var imgSeat: UIImageView!
    @IBOutlet weak var lbSeatNumber: UILabel!
    @IBOutlet weak var dropdown: DropDown!
    @IBOutlet weak var btUpdate: UIButton!
    @IBOutlet weak var btRemove: UIButton!
    @IBOutlet weak var btAdd: UIButton!
    @IBOutlet weak var txtName: MaterialField!
    @IBOutlet weak var txtDocument: MaterialField!
    @IBOutlet weak var cvCard: UICardView!
    @IBOutlet weak var viewDropdown: UIView!
    @IBOutlet weak var ddDocType: DropDown!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewInput: UIView!
    @IBOutlet weak var viewButtonsEdit: UIStackView!
    
    // MARK : VARIABLES
    var clickbusRN = ClickBusRN()
    var sender: UIViewController?
    var delegate: BaseDelegate?
    var currentIndex = 0
    var selectedPassanger = PassengerClickBus()
    var item = ClickBusSeat()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgSeat.image = UIImage(named: "ic_seat")!.withRenderingMode(.alwaysTemplate)
        self.imgSeat.tintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiOrange)
        
        Theme.default.orageButton(self.btUpdate)
        Theme.default.redButton(self.btRemove)
        
        Theme.default.greenButton(self.btAdd)
        
        self.viewInput.isHidden = true
    }
    
    func setIndex(index: Int) {
        self.currentIndex = index
    }
    
    func validate() -> Bool {
        let name = self.txtName.text!
        let document = self.txtDocument.text!
        let docType = self.ddDocType.optionArray[self.ddDocType.selectedIndex!]
        
        if name.isEmpty {
            return false
        }
        
        if document.isEmpty {
            return false
        }
        
        //Verify CPF before letting go
        if docType.lowercased() == "cpf" {
            if !Util.validadeCPF(document) {
                Util.showAlertDefaultOK(self.sender!, message: "genetic_input_error_cpf".localized)
                return false
            }
        }
        
        return true
    }
    
    func openInputForEditing() {
        self.txtName.text = self.selectedPassanger.name
        self.txtDocument.text = self.selectedPassanger.document
        
        self.ddDocType.text = self.selectedPassanger.documentType
        self.ddDocType.selectedIndex = self.selectedPassanger.documentTypePosition
        
        self.viewButtonsEdit.isHidden = false
        self.btAdd.isHidden = true
        self.viewInput.isHidden = false
    }
    
    func openInputForAdd() {
        self.txtName.text = ""
        self.txtDocument.text = ""
        
        self.ddDocType.text = ""
        self.ddDocType.selectedIndex = 0
        
        self.viewButtonsEdit.isHidden = true
        self.btAdd.isHidden = false
        self.viewInput.isHidden = false
    }
    
    @IBAction func onClickEditInput(_ sender: Any) {
        self.openInputForEditing()
        self.delegate?.onReceiveData(fromClass: TicketCell.self, param: Param.Contact.UPDATE_CELL_HEIGHT, result: true, object: self.currentIndex as AnyObject)
    }
    
    @IBAction func onClickUpdate(_ sender: Any) {
        if !validate() {
            return
        }
        
        self.viewInput.isHidden = true
        let name = self.txtName.text!
        let document = self.txtDocument.text!
        let docType = self.ddDocType.optionArray[self.ddDocType.selectedIndex!]
        
        let pass = PassengerClickBus()
        pass.id = self.selectedPassanger.id
        pass.name = name
        pass.document = document
        pass.documentType = docType
        pass.documentTypePosition = self.ddDocType.selectedIndex!
        self.clickbusRN.updatePassenger(passenger: pass)
        
        var objs = [AnyObject]()
        objs.append(self.currentIndex as AnyObject)
        objs.append(pass)
        
        self.selectedPassanger = pass
        self.delegate?.onReceiveData(fromClass: TicketCell.self, param: Param.Contact.USER_UPDATED_IN_ARRAY, result: true, object: objs as AnyObject)
    }
    
    @IBAction func onClickRemove(_ sender: Any) {
        self.viewInput.isHidden = true
        let doc = self.selectedPassanger.document
        self.clickbusRN.removePassenger(document: doc)
        self.selectedPassanger = PassengerClickBus()
        
        self.delegate?.onReceiveData(fromClass: TicketCell.self, param: Param.Contact.USER_REMOVED_FROM_ARRAY, result: true, object: doc as AnyObject)
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        
        if !validate() {
            return
        }
        
        self.viewInput.isHidden = true
        let name = self.txtName.text!
        let document = self.txtDocument.text!
        
        let passenger = PassengerClickBus(name: name, document: document, documentType: self.ddDocType.optionArray[self.ddDocType.selectedIndex!], documentTypePosition: self.ddDocType.selectedIndex!)
        self.clickbusRN.savePassenger(passenger: passenger)
        
        //update passangers
        var objs = [AnyObject]()
        objs.append(self.currentIndex as AnyObject)
        objs.append(passenger)
        self.selectedPassanger = passenger
        
        self.delegate?.onReceiveData(fromClass: TicketCell.self, param: Param.Contact.USER_ADDED_TO_ARRAY, result: true, object: objs as AnyObject)
    }
}
