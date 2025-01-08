//
//  DividaCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividaCell: UIBaseTableViewCell {

    // MARK: Outlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbDateLabel: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    
    // MARK: Variables
    var item: Divida! {

        didSet {
            self.setupUI()
            self.setupTexts()
        }
    }
}

extension DividaCell: SetupUI {

    func setupUI() {
        //Theme.default.textAsListTitle(self.lbValue)
        Theme.default.greenButton(self.btnPay)
    }
    
    func setupTexts() {
        
        self.lbName.text = self.item.lojaName
        self.lbValue.text = Util.formatCoin(value: self.item.valueDivida)
        
        if let status = Constants.StatusDividas(rawValue: item.status) {
            
            if status == .PAGO {
                self.lbDateLabel.text = "dividas_data_pagamento".localized
                self.lbStatus.textColor = Theme.default.green
                
                Theme.default.greenButton(self.btnPay)
                self.imgStatus.image = #imageLiteral(resourceName: "ic_green_done").withRenderingMode(.alwaysTemplate)
                self.imgStatus.tintColor = Theme.default.green
                
                self.lbDate.text = DateFormatterQiwi.formatDate(self.item.datePagamento, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateBrazil)
            }
            else if status == .CANCELADO || status == .VENCIDO{
                self.lbStatus.textColor = Theme.default.red
                
                Theme.default.redButton(self.btnPay)
                self.imgStatus.image = #imageLiteral(resourceName: "ic_red_error")
                
                self.lbDate.text = DateFormatterQiwi.formatDate(self.item.dateVencimento, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateBrazil)
            }
            else {
                self.lbDateLabel.text = "dividas_data_validade".localized
                self.lbStatus.textColor = Theme.default.yellow
                
                Theme.default.orageButton(self.btnPay)
                self.imgStatus.image = #imageLiteral(resourceName: "ic_pending").withRenderingMode(.alwaysTemplate)
                self.imgStatus.tintColor = Theme.default.orange
                
                self.lbDate.text = DateFormatterQiwi.formatDate(self.item.dateVencimento, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: DateFormatterQiwi.dateBrazil)
            }
            
            self.lbStatus.text = Divida.getStatusName(status: status)
        }
        
        self.btnPay.setTitle("dividas_list_pay_button".localized, for: .normal)
    }
}
