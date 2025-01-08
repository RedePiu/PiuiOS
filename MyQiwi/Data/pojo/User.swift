//
//  User.swift
//  MyQiwi
//
//  Created by ailton on 31/12/16.
//  Copyright © 2016 Qiwi. All rights reserved.
//

import ObjectMapper

public class User: BasePojo {
    
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var cpf: String = ""
    @objc dynamic var cel: String = ""
    @objc dynamic var picture: String = ""
    @objc dynamic var note: Int = 0
    @objc dynamic var hasToken: Bool = false
    @objc dynamic var sentDoc: Bool = false
    @objc dynamic var lastLoginDate: String = ""
    @objc dynamic var lastLoginTime: String = ""
    @objc dynamic var isQiwiAccountactive: Bool = false
    @objc dynamic var usaATM: Bool = false
    @objc dynamic var isAdesaoDigital: Bool = false
    @objc dynamic var isContaPrePaga: Bool = false
    @objc dynamic var canShowReceiptPrePago: Bool = false
    var taxes: [Tax]?
    var coupons: [Coupon]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override public func mapping(map: Map) {
        
        name <- map["nome"]
        email <- map["email"]
        cpf <- map["cpf"]
        cel <- map["num_celular"]
        picture <- map["foto"]
        note <- map["nota"]
        hasToken <- map["existeToken"]
        sentDoc <- map["fl_documento"]
        isQiwiAccountactive <- map["contaQiwiAtiva"]
        usaATM <- map["usaATM"]
        isAdesaoDigital <- map["fl_adesao_digital"]
        isContaPrePaga <- map["contaPrePaga"]
        canShowReceiptPrePago <- map["fl_comprovante_prepago"]
        taxes <- map["taxa"]
        coupons <- map["cupons"]
    }
    
    convenience init(name: String, lastLoginDate: String, lastLoginTime: String) {
        self.init()
        
        self.name = name
        self.lastLoginDate = lastLoginDate
        self.lastLoginTime = lastLoginTime
    }
}

extension User {
    
    // MARK: Methods
    
    func getFirstName() -> String {
        
        var fname = ""
        
        if !name.isEmpty {
            
            let characters = name.split(separator: " ")
            fname = String(characters.first ?? "")
        }
        
        return fname
    }
    
    func getFormattedCel() -> String {
        
        var formatCel = ""
        
        if !cel.isEmpty {
            let ddd = String(format: "(%@)", cel[0..<2])
            let number = String(format: "%@", cel[2..<cel.count])
            formatCel = String(format: "%@ %@", ddd, number)
        }
        
        return formatCel
    }
    
    func getCensoredCel() -> String {
        
        var censoredCel = ""
        
        if !cel.isEmpty {
            censoredCel = String(format: "%@*****%@", cel[0..<5], cel[8..<cel.count])
        }
        
        return censoredCel
    }
}
