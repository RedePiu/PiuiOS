//
//  ComprovanteDividaCell.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 18/06/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation
import UIKit

class ComprovanteDepositoCell: UIBaseCollectionViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbCode: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var btnRemover: UIButton!
    
    var delegate: BaseDelegate?
    var position: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareCell()
    }
    
    func prepareCell() {
        self.lbCode.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
    }
    
    func displayContent(receipt: DividaReceipt, position: Int, delegate: BaseDelegate) {
        self.lbCode.text = receipt.code
        self.lbValue.text = Util.formatCoin(value: receipt.value)
        self.imgIcon.image = UIImage.init(contentsOfFile: receipt.attaches.first!.path)
        self.position = position
        self.delegate = delegate
    }
    
    @IBAction func onClickRemover(_ sender: Any) {
        self.delegate?.onReceiveData(fromClass: ComprovanteDepositoCell.self, param: Param.Contact.LIST_REMOVE_ITEM, result: true, object: position as AnyObject)
    }
}
