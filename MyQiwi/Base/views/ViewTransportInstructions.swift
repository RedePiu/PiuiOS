//
//  ViewTransportInstructions.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 25/07/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class ViewTransportInstructions: LoadBaseView {
    
    @IBOutlet weak var lblTransportTitle: UILabel!
    @IBOutlet weak var lbUrbsAlert: UILabel!
    @IBOutlet weak var lblTransportDesc: UILabel!
    
    @IBOutlet weak var lbUrbsWarning: UILabel!
    
    // MARK: Init
    
    override func initCoder() {
        self.loadNib(name: "ViewTransportInstructions")
        self.setupTransportInstructions()
    }
}

extension ViewTransportInstructions {
    
    func showUrbsAlert() {
        self.lbUrbsAlert.isHidden = false
    }
    
    func showUrbsAlert(rechargeDate: String) {
        
        self.lbUrbsWarning.isHidden = false
        
        let date = DateFormatterQiwi.stringToDate(date: rechargeDate)
        let hour = Calendar.current.dateComponents([.hour], from: date).hour ?? 0
        
        let currentHour = Calendar.current.dateComponents([.hour], from: Date()).hour ?? 0
        self.lbUrbsAlert.isHidden = false
        self.lblTransportDesc.text = "transport_inst_desc_urbs".localized
        
        //Se for no mesmo dia
        if Calendar.current.isDateInToday(date) {
            
            //Disponivel amanhã
            if hour < 22 {
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
                let availableDate = DateFormatterQiwi.formatDate(date: tomorrow, format: "dd 'de' MMMM 'de' yyyy")
                lbUrbsAlert.text = "Sua recarga estará disponível a partir de " + availableDate
            } else {
                lbUrbsAlert.text = "Sua recarga estará disponível em até 24 horas"
            }
        }
        
        //Se for de um dia atrás
        else if Calendar.current.isDateInYesterday(date) && hour >= currentHour{
            lbUrbsAlert.text = "Sua recarga estará disponível em até 24 horas"
        }
        else {
            lbUrbsAlert.isHidden = true
        }
    }
    
    func show72HourRemaining() {
        self.lblTransportDesc.text = "transport_inst_desc_urbs".localized
        self.lbUrbsAlert.isHidden = false
        self.lbUrbsWarning.isHidden = true
    }
    
    func hideUrbsAlert() {
        self.lblTransportDesc.text = "transport_inst_desc".localized
        self.lbUrbsAlert.isHidden = true
        self.lbUrbsWarning.isHidden = true
    }
    
    func showUrbsCondition() {
        self.lbUrbsWarning.isHidden = false
    }
    
    func hide72HourRemaining() {
        self.lbUrbsAlert.isHidden = true
    }
}

// MARK: Setup UI
extension ViewTransportInstructions {

    fileprivate func setupTransportInstructions() {
        
        Theme.TransportInstructions.textAsTitle(self.lblTransportTitle)
        Theme.TransportInstructions.textAsDesc(self.lblTransportDesc)
        
        self.lbUrbsAlert.isHidden = true
        
        self.lblTransportTitle.text = "transport_inst_title".localized
        self.lblTransportDesc.text = "transport_inst_desc".localized
    }
}


