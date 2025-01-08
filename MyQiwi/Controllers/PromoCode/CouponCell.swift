//
//  CouponCell.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class CouponCell: UIBaseCollectionViewCell {

    // MARK: Outlets
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbExpiration: UILabel!
    @IBOutlet weak var lbProducts: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.didUnselect()
    }
    
    // MARK: Methods
    func displayContent(coupon: Coupon, comingFrom: PromoCodeViewController.comingFromOptions, currentPrvid: Int, isSelected: Bool = false) {
        
        if isSelected {
            self.didSelect()
        } else {
            self.didUnselect()
        }
        
        self.lbName.text = coupon.code.formatText(format: "####-####-####-####")
        self.lbExpiration.text = DateFormatterQiwi.formatDate(coupon.expiration, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateBrazil)
        //self.lbExpiration.text = "23/04/2020"
        self.lbValue.text = Util.formatCoin(value: coupon.value)
        
        if !coupon.products.isEmpty {
            
            var products = "coupon_product_list".localized
            for i in 0..<coupon.products.count {
                
                //Não adiciona se não vier nome
                if coupon.products[i].name.isEmpty || products.contains(coupon.products[i].name.lowercased()) {
                    continue
                }
                
                products += coupon.products[i].name.lowercased()
                
                if i < coupon.products.count-1 {
                    products += ", "
                }
            }
            
            self.lbProducts.text = products
        } else {
            self.lbProducts.text = "coupon_product_list_all".localized
        }
        
        var icon = ""
        if comingFrom == .HOME || (comingFrom == .CHECKOUT && coupon.isCouponAvailableForPrvAndValue(prvid: currentPrvid, value: QiwiOrder.getValue())) || (comingFrom == .PAYMENT_METHODS && coupon.isCouponAvailableForCouponPaymentMethod(prvid: currentPrvid, value: QiwiOrder.getValue())) {
            icon = coupon.isAcumulative ? "ic_coupon_green" : "ic_coupon_on"
        }
        else {
            icon = "ic_coupon_off"
        }
        
        self.imgIcon.image = UIImage(named: icon)
    }
    
    func didSelect() {
        self.lbName.textColor = UIColor(hexString: Constants.Colors.Hex.white)
        self.lbValue.textColor = UIColor(hexString: Constants.Colors.Hex.white)
        self.lbExpiration.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey2)
        self.lbProducts.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey2)
        
        self.contentView.layer.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorGrey9).cgColor
    }
    
    func didUnselect() {
        self.lbName.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.lbValue.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        self.lbExpiration.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        self.lbProducts.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        
        self.contentView.layer.backgroundColor = UIColor(hexString: Constants.Colors.Hex.white).cgColor
    }
}

