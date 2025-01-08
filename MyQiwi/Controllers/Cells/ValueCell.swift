//
//  ValueCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ValueCell: UIBaseCollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var tvValue: UILabel!
    @IBOutlet weak var widthLayout: NSLayoutConstraint?
    @IBOutlet weak var lbValueAux: UILabel!
    @IBOutlet weak var lbValueAux2: UILabel!
    
    // MARK: Variables
    
    var widthCollection: CGFloat = 120 {
        didSet {
            self.setCellWidth((widthCollection - (CGFloat(2) * 10)) / 2)
        }
    }
    
    // MARK: Methods
    
    func setCellWidth(_ width: CGFloat) {
        widthLayout?.constant = width
    }
    
    public func displayValue(value: Int, aux: String = "", aux2: String = "") -> Void {
        
        if value == -1 {
            tvValue.text = "select_value_other_value".localized
            return
        }
        
        tvValue.text = Util.formatCoin(value: value)
        lbValueAux.text = aux
        lbValueAux2.text = aux2
        lbValueAux.isHidden = aux.isEmpty
        lbValueAux2.isHidden = aux2.isEmpty
    }
    
    public func displayValue(value: Double, aux: String = "", aux2: String = "") -> Void {
        
        if value == -1 {
            tvValue.text = "select_value_other_value".localized
            return
        }
        
        tvValue.text = Util.formatCoin(value: value)
        
        lbValueAux.text = aux
        lbValueAux2.text = aux2
        lbValueAux.isHidden = aux.isEmpty
        lbValueAux2.isHidden = aux2.isEmpty
    }
    
    public func displayValue(desc: String, aux: String = "", aux2: String = "") -> Void {
        
        tvValue.text = desc
        lbValueAux.text = aux
        lbValueAux.isHidden = aux.isEmpty
        
        lbValueAux2.text = aux2
        lbValueAux2.isHidden = aux2.isEmpty
    }

}
