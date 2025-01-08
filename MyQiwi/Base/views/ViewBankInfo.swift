//
//  ViewBankInfo.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewBankInfo: LoadBaseView {
    
    // MARK: Outlets
    
    @IBOutlet weak var imgBank: UIImageView!
    @IBOutlet weak var lbBankName: UILabel!
    @IBOutlet weak var lbFavored: UILabel!
    @IBOutlet weak var lbBankWarning: UILabel!
    @IBOutlet weak var lbBankInfo: UILabel!
    @IBOutlet weak var lbBankTransferWarningInfo: UILabel!
    @IBOutlet weak var lbBankTransferInfo: UILabel!
    
    // MARK: Init
    var isDivida = false
    var isBoleto = false
    
    override func initCoder() {
        self.loadNib(name: "ViewBankInfo")
        self.setupBankInfo()
    }
}

// MARK: Setup UI
extension ViewBankInfo {
    
    fileprivate func setupBankInfo() {
        
        Theme.BankInfo.textAsName(self.lbBankName)
        Theme.BankInfo.textAsFavored(self.lbFavored)
        Theme.BankInfo.textAsBankTransferInfo(self.lbBankTransferWarningInfo)
        Theme.BankInfo.textAsBankInfo(self.lbBankInfo)
        Theme.BankInfo.textAsBankWarning(self.lbBankWarning)
        Theme.BankInfo.textAsBankTransferInfo(self.lbBankTransferInfo)

        self.lbBankWarning.text = "checkout_bank_transfer_info_warning".localized
        self.lbBankTransferInfo.text = "checkout_bank_transfer_info".localized
    }
    
    func setBankInfo(bank: Bank, value: Double, isDivida: Bool = false, isDeposito: Bool = false) {
        self.setBankInfo(bank: bank, value: Int(value * 100), isDivida: isDivida, isDeposito: isDeposito)
    }
    
    func setBankInfo(bank: Bank, value: Int, isDivida: Bool = false, isDeposito: Bool = false) {
        self.lbBankName.text = bank.bankName
        self.lbFavored.text = bank.ownerName //"Qiwi Tecnologia S.A"
        
        self.lbBankInfo.text = "checkout_bank_bank_info".localized
            .replacingOccurrences(of: "{agency}", with: bank.agency)
            .replacingOccurrences(of: "{account}", with: bank.account)
            .replacingOccurrences(of: "{digit}", with: bank.accoutDigit)
        
        let formattedImage = Util.formatImagePath(path: String(bank.id))
        self.imgBank.image = UIImage(named: formattedImage)
        
        var bankTransferWarning = "checkout_bank_transfer_warning".localized
        
        if isDivida {
            bankTransferWarning = isDeposito ? "checkout_bank_deposito_warning".localized : "checkout_bank_transfer_warning".localized
            
            self.lbBankWarning.isHidden = isDeposito
            self.lbBankTransferWarningInfo.text = bankTransferWarning
            .replacingOccurrences(of: "{value}", with: "\(Util.formatCoin(value: value))")
            
            self.lbBankTransferInfo.text = "checkout_bank_transfer_and_deposito_info".localized
        }
        else {
            
            self.lbBankTransferWarningInfo.text = bankTransferWarning
            .replacingOccurrences(of: "{value}", with: "\(Util.formatCoin(value: value))")
            
            self.lbBankTransferInfo.text = "checkout_bank_transfer_info".localized
        }
    }
}
