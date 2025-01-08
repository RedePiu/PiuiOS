//
//  UltragazProductPriceCell.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 02/09/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class UltragazProductPriceCell: UIBaseCollectionViewCell {
    
    // MARK: Outlets
       
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var btnLess: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    
    public var enabled = true
    public var pos: Int = 0
    public var amount: Int = 0
    public var product: UltragazProduct?
    public var viewController: UltragazProductListViewController?
    
    public func displayValue(_ viewController: UltragazProductListViewController, pos: Int, product: UltragazProduct, amount: Int, enabled: Bool) -> Void {
        self.viewController = viewController
        self.pos = pos
        self.product = product
        self.amount = amount
        self.enabled = enabled
        
        lbValue.text = Util.formatCoin(value: product.value)
        lbName.text = product.name
        
        btnLess.isUserInteractionEnabled = enabled
        btnMore.isUserInteractionEnabled = enabled 
        
        self.updateAmount(amount: amount)
    }
    
    @IBAction func onClickLess(_ sender: Any) {

        if !enabled {
            return
        }
        
        self.updateAmount(amount: amount-1)
        self.viewController?.removeFromPrice(product: product!, pos: self.pos, amount: self.amount)
    }
    
    @IBAction func onClickMore(_ sender: Any) {

        if !enabled {
            return
        }
        
        self.updateAmount(amount: amount+1)
        self.viewController?.addToPrice(product: product!, pos: self.pos, amount: self.amount)
    }
    
    public func updateAmount(amount: Int) {
        
        if  amount < 0 || amount > 5 {
            return
        }
        
        self.amount = amount
        lbAmount.text = String(amount)
        
        if !enabled {
            btnLess.setImage(UIImage(named: "ic_less_gray"), for: .normal)
            btnMore.setImage(UIImage(named: "ic_plus_gray"), for: .normal)
            return
        }
        
        if amount == 0 {
            btnLess.setImage(UIImage(named: "ic_less_gray"), for: .normal)
            btnMore.setImage(UIImage(named: "ic_plus_green"), for: .normal)
        }
        else if amount == 5 {
            btnLess.setImage(UIImage(named: "ic_less_red"), for: .normal)
            btnMore.setImage(UIImage(named: "ic_plus_gray"), for: .normal)
        }
        else {
            btnLess.setImage(UIImage(named: "ic_less_red"), for: .normal)
            btnMore.setImage(UIImage(named: "ic_plus_green"), for: .normal)
        }
        
        self.viewController?.updateContinueButton()
    }
}
