//
//  ViewCaixaEconomica.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 30/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ViewCaixaEconomica: LoadBaseView {
    
    // MARK: Outlets
    @IBOutlet weak var viewStatus: UIStackView!
    @IBOutlet weak var viewCode: UIStackView!
    @IBOutlet weak var viewLoading: UIStackView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var txtCode: MaterialField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lbLoading: UILabel!
    @IBOutlet weak var ivStatus: UIImageView!
    @IBOutlet weak var lbStatusTitle: UILabel!
    @IBOutlet weak var lbStatusDesc: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    // MARK: Variables
    var orderId: Int = 0
    var dividaId: Int = 0
    var caixaCode: String = ""
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewCaixaEconomica")
        self.setupView()
        self.setupTextFields()
    }
    
}

// MARK: IBAction

extension ViewCaixaEconomica {
    
    @IBAction func onClickSend(_ sender: Any) {
        let code = self.txtCode.text!
        
        if code.count < 3 {
            Util.showAlertDefaultOK(self.viewContainingController()!, message: "order_caixa_economica_input_error".localized)
            return
        }
        
        self.caixaCode = code
        self.sendCodeRequest()
    }
    
    @IBAction func onClickResent(_ sender: Any) {
        self.showCodeLayout()
    }
}

extension ViewCaixaEconomica {
    
    public func setOrderId(orderId: Int) {
        self.orderId = orderId
    }
    
    public func setDividaId(dividaId: Int) {
        self.dividaId = dividaId
    }
    
    public func setCaixaCode(dividaId: Int, caixaCode: String) {
        self.dividaId = dividaId
        self.caixaCode = caixaCode
        
        self.showStatusLayout(success: true)
    }
    
    public func setCaixaCode(orderId: Int, caixaCode: String) {
        self.orderId = orderId
        self.caixaCode = caixaCode
        
        self.showStatusLayout(success: true)
    }
    
    func sendCodeRequest() {
        Util.showLoading(self.viewContainingController()!)
        
        if self.orderId > 0 {
            OrderRN(delegate: self).sendOrderComplement(orderId: self.orderId, caixaCode: self.txtCode.text!)
        } else {
            DividaRN(delegate: self).sendCaixaCode(dividaId: self.dividaId, caixaCode: self.txtCode.text!)
        }
    }
}

extension ViewCaixaEconomica : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            self.viewContainingController()!.dismiss(animated: true, completion: nil)
            
            if param == Param.Contact.ORDERS_SEND_COMPLEMENT_RESPONSE {
                self.showStatusLayout(success: result)
            }
            
            if param == Param.Contact.DIVIDA_CAIXA_COMPLEMENT {
                self.showStatusLayout(success: result)
            }
        }
    }
}

extension ViewCaixaEconomica {
    
    public func showLoadingLayout() {
        self.viewCode.isHidden = true
        self.viewStatus.isHidden = true
        self.viewLoading.isHidden = false
    }
    
    public func showCodeLayout() {
        self.viewStatus.isHidden = true
        self.viewLoading.isHidden = true
        self.viewCode.isHidden = false
    }
    
    public func showStatusLayout(success: Bool) {
        self.viewCode.isHidden = true
        self.viewLoading.isHidden = true
        self.viewStatus.isHidden = false
        
        if success {
            self.ivStatus.image = UIImage(named: "ic_green_done")
            Theme.default.greenButton(self.btnContinue)
            
            self.lbStatusTitle.text = "order_caixa_economica_send_success".localized
            self.lbStatusDesc.text = "order_caixa_economica_send_success_desc".localized
                .replacingOccurrences(of: "{code}", with: self.caixaCode)
        } else {
            self.ivStatus.image = UIImage(named: "ic_red_error")
            Theme.default.redButton(self.btnContinue)
            
            self.lbStatusTitle.text = "order_caixa_economica_send_fail".localized
            self.lbStatusDesc.text = "order_caixa_economica_send_fail_desc".localized
        }
    }
}

// MARK: Setup
extension ViewCaixaEconomica {
    
    func setupView() {
        Theme.default.blueButton(self.btnSend)
        
        Theme.default.textAsListTitle(self.lbStatusTitle)
        Theme.BankInfo.textAsBankTransferInfo(self.lbDesc)
        Theme.BankInfo.textAsBankTransferInfo(self.lbStatusDesc)

        self.showCodeLayout()
    }
    
    func setupTextFields() {
        //self.txtCode.formatPattern = Constants.FormatPattern.CreditCard.CVV.rawValue
        
        self.lbDesc.text = "order_caixa_economica_op_code_desc".localized
        
        self.txtCode.placeholder = "order_caixa_economica_op_code_hint".localized
        self.btnSend.setTitle("order_caixa_economica_send_button".localized, for: .normal)
        self.btnContinue.setTitle("order_caixa_economica_status_button".localized, for: .normal)
    }
}
