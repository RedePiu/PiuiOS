//
//  UrbsRegistry.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class UrbsRegistry : BasePojo {

    @objc dynamic var date: String = ""
    @objc dynamic var wallet: Int = 0
    @objc dynamic var operation: String = ""
    @objc dynamic var lineCod: String = ""
    @objc dynamic var line: String = ""
    @objc dynamic var trecho: String = ""
    @objc dynamic var externalCodeVehicle: String = ""
    @objc dynamic var cobradorMatricula: String = ""
    @objc dynamic var cobradorNome: String = ""
    @objc dynamic var value: Double = 0
    @objc dynamic var cardBalance: Double = 0
    @objc dynamic var scheduledBalance: Double = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        date <- map["dataOperacao"]
        wallet <- map["carteira"]
        operation <- map["operacao"]
        lineCod <- map["codigoLinha"]
        line <- map["trecho"]
        trecho <- map["codigoExternoVeiculo"]
        externalCodeVehicle <- map["matriculaCobrador"]
        cobradorMatricula <- map["nomeCobrador"]
        value <- map["valor"]
        cardBalance <- map["saldoCartao"]
        scheduledBalance <- map["saldoAgendado"]
    }
    
    convenience init(date: String, local: String, balance: Double, value: Double) {
        self.init()
        self.date = date
        self.trecho = local
        self.cardBalance = balance
        self.value = value
        
    }
}
