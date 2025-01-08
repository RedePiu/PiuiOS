//
//  TelesenaProductCell.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 24/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class TelesenaProductCell: UIBaseCollectionViewCell {
    
    // MARK: Outlets
       
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    var delegate: BaseDelegate?
    var product = TelesenaProduct()
    
    override func awakeFromNib() {
        Theme.default.greenButton(self.btnSelect)
    }
    
    public func displayValue(_ delegate: BaseDelegate, product: TelesenaProduct) -> Void {
        self.delegate = delegate
        self.product = product
        
        self.lbValue.text = Util.formatCoin(value: product.value)
        self.lbName.text = product.desc
    }
   
    @IBAction func onClickSelect(_ sender: Any) {
        self.delegate?.onReceiveData(fromClass: TelesenaProductCell.self, param: Param.Contact.ITEM_CLICK, result: true, object: self.product)
    }
}

