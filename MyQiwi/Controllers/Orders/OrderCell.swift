//
//  OrderCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class OrderCell: UIBaseTableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgBank: UIImageView!
    @IBOutlet weak var lbProduct: UILabel!
    @IBOutlet weak var lbOrderNumber: UILabel!
    @IBOutlet weak var lbOrderStatus: UILabel!
    @IBOutlet weak var lbOrderDate: UILabel!
    @IBOutlet weak var lbOrderPrice: UILabel!
    @IBOutlet weak var lbOrderBank: UILabel!
    @IBOutlet weak var lbOrderPaymentMethod: UILabel!
    @IBOutlet weak var lbDetails: UILabel!
    @IBOutlet weak var btnDetails: UIButton!

    @IBOutlet weak var lbDescOrderNumber: UILabel!
    @IBOutlet weak var lbDescOrderDate: UILabel!
    @IBOutlet weak var lbDescOrderPrice: UILabel!
    @IBOutlet weak var lbDescOrderPaymentMethod: UILabel!
    @IBOutlet weak var lbDescOrderBank: UILabel!
        @IBOutlet weak var lbDescOrderDetails: UILabel!
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewBankInfo: UIView!
    
    @IBOutlet weak var imgCashback: UIImageView!
    @IBOutlet weak var viewCashback: UIView!
    @IBOutlet weak var lbCashback: UILabel!
    
    // MARK: Variables
    var item: Order! {
        
        didSet {
            self.setupUI()
            self.setupTexts()
            self.fillFields(order: self.item)
        }
    }
    
    // MARK: Metodos Customizados

    func fillFields(order: Order) {
        
        self.setStatusOrder(order: order)
        self.setPaymentOrder(paymentValue: self.item.paymentMethod.rawValue)
        
        self.lbProduct.text = order.name
        self.lbOrderNumber.text = "\(order.id)"
        self.lbOrderDate.text = Util.formatDate(order.date)
        self.lbOrderPrice.text = Util.formatCoin(value: order.value).currencyInputFormatting()
        
        if !order.details.isEmpty {
            self.viewDetails.isHidden = false
            self.viewDetails.superview?.isHidden = false
            self.lbDetails.text = order.details
        } else {
            self.viewDetails.isHidden = true
            self.viewDetails.superview?.isHidden = true
        }
        
        if order.paymentMethod.rawValue == Order.Payment.bank_transfer.rawValue {
            var bankInfo = order.bankAgency! + " // " + order.bankAccount!
            
            if order.bankAccountDv != nil && !(order.bankAccountDv?.isEmpty)! {
                bankInfo = bankInfo + "-" + order.bankAccountDv!
            }
            
//            let bank = PaymentRN(delegate: self).getBank(bankId: order.bankId!)
//            bankInfo = bankInfo + " (" + bank.bankName + ")"
            self.lbOrderBank.text = bankInfo
            self.imgBank.image = UIImage(named: String(order.bankId!))
            
            self.viewBankInfo.isHidden = false
            self.imgBank.isHidden = false
        } else {
            self.imgBank.isHidden = true
            self.viewBankInfo.isHidden = true
        }
        
        
        if order.hasCashback {
            self.imgCashback.setImage(named: "ic_cashback")
            self.lbCashback.text = "cash_back_available".localized.replacingOccurrences(of: "{value}", with: Util.formatCoin(value: order.cashbackValue))
            self.viewCashback.isHidden = false
            self.imgCashback.isHidden = false
        } else {
            self.imgCashback.setImage(named: "")
            self.viewCashback.isHidden = true
            self.imgCashback.isHidden = true
        }
        
        setImage(imageName: String(order.prvId))
    }
    
    func setImage(imageName: String) {
        let image = UIImage(named: imageName) ?? UIImage(named: "ic_no_image")
        imgProduct.image = image
    }
}

extension OrderCell {
    

    func setPaymentOrder(paymentValue: Int) {
        
        if let paymentMethod = Order.Payment(rawValue: paymentValue) {
            
            self.lbOrderPaymentMethod.text = item.getPaymentOrder()
            
            switch paymentMethod {
                
            case .null:
            self.lbOrderBank.superview?.isHidden = true
                break
            case .credit_card:
                self.lbOrderBank.superview?.isHidden = true
                break
            case .qiwi_account:
                self.lbOrderBank.superview?.isHidden = true
                break
            case .bank_transfer:
                self.lbOrderBank.superview?.isHidden = false
                break
            case .pre_pago:
                self.lbOrderBank.superview?.isHidden = false
                break
            case .pix:
                self.lbOrderBank.superview?.isHidden = true
                break
            case .coupon:
                self.lbOrderBank.superview?.isHidden = true
                break
            }
        }
    }
    
    func setStatusOrder(order: Order) {
        
        if let statusOrder = Order.Status(rawValue: order.status.rawValue) {
            
            self.lbOrderStatus.text = item.getStatusOrder()
            self.btnDetails.setTitle("Detalhar", for: .normal)
            
            switch statusOrder {
                
            case .canceled:
                
                self.lbOrderStatus.textColor = Theme.default.red
                Theme.default.redButton(self.btnDetails)
                self.imgStatus.image = #imageLiteral(resourceName: "ic_red_error")
                
                break
            case .pendent:
                
                self.lbOrderStatus.textColor = Theme.default.orange
                Theme.default.orageButton(self.btnDetails)
                self.imgStatus.image = #imageLiteral(resourceName: "ic_pending").withRenderingMode(.alwaysTemplate)
                self.imgStatus.tintColor = Theme.default.orange
                
//                if order.isCaixaOrder() && !order.isCaixaOrderCodeSent() {
//                    self.btnDetails.setTitle("Digitar Código", for: .normal)
//                }
                
                break
            case .finished:
                
                self.lbOrderStatus.textColor = Theme.default.green
                Theme.default.greenButton(self.btnDetails)
                self.imgStatus.image = #imageLiteral(resourceName: "ic_green_done").withRenderingMode(.alwaysTemplate)
                self.imgStatus.tintColor = Theme.default.green
                
                break
            }
        }
    }
}

extension OrderCell: SetupUI {
    
    func setupUI() {
        
        // Titulos
        self.lbProduct.font = FontCustom.helveticaBold.font(16)
        self.lbProduct.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        self.lbProduct.adjustsFontForContentSizeCategory = true
        
        self.lbDescOrderNumber.font = FontCustom.helveticaRegular.font(16)
        self.lbDescOrderNumber.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbDescOrderNumber.adjustsFontForContentSizeCategory = true
        
        self.lbDescOrderDate.font = FontCustom.helveticaRegular.font(15)
        self.lbDescOrderDate.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbDescOrderDate.adjustsFontForContentSizeCategory = true
        
        self.lbDescOrderPrice.font = FontCustom.helveticaRegular.font(15)
        self.lbDescOrderPrice.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbDescOrderPrice.adjustsFontForContentSizeCategory = true
        
        self.lbDescOrderPaymentMethod.font = FontCustom.helveticaRegular.font(15)
        self.lbDescOrderPaymentMethod.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbDescOrderPaymentMethod.adjustsFontForContentSizeCategory = true
        
        self.lbDescOrderBank.font = FontCustom.helveticaRegular.font(15)
        self.lbDescOrderBank.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbDescOrderBank.adjustsFontForContentSizeCategory = true
        
        self.lbDescOrderDetails.font = FontCustom.helveticaRegular.font(15)
        self.lbDescOrderDetails.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbDescOrderDetails.adjustsFontForContentSizeCategory = true
        
        // Valores
        self.lbOrderNumber.font = FontCustom.helveticaBold.font(15)
        self.lbOrderNumber.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey8)
        self.lbOrderNumber.adjustsFontForContentSizeCategory = true
        
        self.lbOrderDate.font = FontCustom.helveticaBold.font(15)
        self.lbOrderDate.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey8)
        self.lbOrderDate.adjustsFontForContentSizeCategory = true
        
        self.lbOrderPrice.font = FontCustom.helveticaBold.font(15)
        self.lbOrderPrice.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey8)
        self.lbOrderPrice.adjustsFontForContentSizeCategory = true
        
        self.lbOrderPaymentMethod.font = FontCustom.helveticaBold.font(15)
        self.lbOrderPaymentMethod.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey8)
        self.lbOrderPaymentMethod.adjustsFontForContentSizeCategory = true
        
        self.lbOrderBank.font = FontCustom.helveticaBold.font(15)
        self.lbOrderBank.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey8)
        self.lbOrderBank.adjustsFontForContentSizeCategory = true
        
        self.lbDetails.font = FontCustom.helveticaBold.font(15)
        self.lbDetails.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey8)
        self.lbDetails.adjustsFontForContentSizeCategory = true
        
        self.lbOrderStatus.font = FontCustom.helveticaMedium.font(18)
        self.lbOrderStatus.adjustsFontForContentSizeCategory = true
        
        self.lbCashback.font = FontCustom.helveticaRegular.font(16)
        self.lbCashback.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        self.lbCashback.adjustsFontForContentSizeCategory = true
        
//        self.setStatusOrder(statusValue: 1)
    }
    
    func setupTexts() {
        self.lbProduct.text = "Recarga Operadora"
        self.lbOrderNumber.text = "0000000"
        self.lbOrderDate.text = "00/00/00 as 00:00"
        self.lbOrderPrice.text = "R$ 00,00"
        self.lbOrderStatus.text = "Não encontrado"
        self.lbOrderPaymentMethod.text = "Não encontrado"
        self.lbOrderBank.text = "0000 // 00000-0 (Banco)"
        
        self.lbDescOrderNumber.text = "order_order_number".localized
        self.lbDescOrderDate.text = "order_order_date".localized
        self.lbDescOrderPrice.text = "order_order_price".localized
        self.lbDescOrderPaymentMethod.text = "order_order_payment_method".localized
        self.lbDescOrderBank.text = "order_selected_bank".localized
        
        self.lbCashback.text = "cash_back_available".localized
    }
}

extension OrderCell: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
    }
}
