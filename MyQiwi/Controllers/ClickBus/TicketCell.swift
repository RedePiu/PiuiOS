//
//  TicketCell.swift
//  MyQiwi
//
//  Created by Thyago on 06/09/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import iOSDropDown

class TicketCell: UIBaseTableViewCell {
    
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
    
    // MARK : VARIABLES
    var clickbusRN = ClickBusRN()
    var sender: UIViewController?
    var delegate: BaseDelegate?
    var currentIndex = 0
    var selectedPassanger = PassengerClickBus()
    
    var item: ClickBusSeat! {

        didSet {

            self.imgSeat.image = UIImage(named: "ic_seat")!.withRenderingMode(.alwaysTemplate)
            self.setLayout()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setLayout() {

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
        
        if name.isEmpty {
            return false
        }
        
        if document.isEmpty {
            return false
        }
        
        return true
    }
    
    func openInputForEditing() {
        self.txtName.text = self.selectedPassanger.name
        self.txtDocument.text = self.selectedPassanger.document
        
        self.ddDocType.text = self.selectedPassanger.documentType
        self.ddDocType.selectedIndex = self.selectedPassanger.documentTypePosition
        
        self.viewInput.isHidden = false
    }
    
    func openInputForAdd() {
        self.txtName.text = ""
        self.txtDocument.text = ""
        
        self.ddDocType.text = ""
        self.ddDocType.selectedIndex = 0
        
        self.viewInput.isHidden = false
    }
    
    @IBAction func onClickEditInput(_ sender: Any) {
        self.openInputForEditing()
        self.delegate?.onReceiveData(fromClass: TicketCell.self, param: Param.Contact.UPDATE_CELL_HEIGHT, result: true, object: self.currentIndex as AnyObject)
    }
    
    @IBAction func onClickUpdate(_ sender: Any) {
        self.viewInput.isHidden = true
        let name = self.txtName.text!
        let document = self.txtDocument.text!

//        let pass = PassengerClickBus(name: name, document: document, documentType: self.ddDocType.optionArray[self.ddDocType.selectedIndex!], documentTypePosition: self.ddDocType.selectedIndex!)
        
//        self.selectedPassanger.name = name
//        self.selectedPassanger.document = document
//        self.selectedPassanger.documentType = self.ddDocType.optionArray[self.ddDocType.selectedIndex!]
//        self.selectedPassanger.documentTypePosition = self.ddDocType.selectedIndex!
//        self.clickbusRN.updatePassenger(passenger: self.selectedPassanger)
        
        let pass = PassengerClickBus()
        pass.id = self.selectedPassanger.id
        pass.name = name
        pass.document = document
        pass.documentType = self.ddDocType.optionArray[self.ddDocType.selectedIndex!]
        pass.documentTypePosition = self.ddDocType.selectedIndex!
        self.clickbusRN.updatePassenger(passenger: pass)
        
        self.delegate?.onReceiveData(fromClass: TicketCell.self, param: Param.Contact.UPDATE_PASSENGERS, result: true, object: self.currentIndex as AnyObject)
    }
    
    @IBAction func onClickRemove(_ sender: Any) {
        self.viewInput.isHidden = true
        self.clickbusRN.removePassenger(passenger: self.selectedPassanger)
        self.selectedPassanger = PassengerClickBus()
        
        self.delegate?.onReceiveData(fromClass: TicketCell.self, param: Param.Contact.UPDATE_PASSENGERS, result: true, object: self.currentIndex as AnyObject)
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
        
        self.delegate?.onReceiveData(fromClass: TicketCell.self, param: Param.Contact.USER_ADDED_TO_ARRAY, result: true, object: objs as AnyObject)
    }
}
