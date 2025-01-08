//
//  BusTicketCharge.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 12/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class BusTicketCharge: BasePojo {
    
    @objc dynamic var isOnlyGo = true
    
    var cityDeparture: ClickBusCity?
    var cityDestiny: ClickBusCity?
    
    @objc dynamic var scheduleIdGo: String = ""
    @objc dynamic var scheduleIdBack: String = ""
    @objc dynamic var sessionIdGo: Int = 0
    @objc dynamic var sessionIdBack: Int = 0
    var seatsGo = [ClickBusSeat]()
    var seatsBack = [ClickBusSeat]()
    @objc dynamic var ticketPriceGo: Int = 0
    @objc dynamic var ticketPriceBack: Int = 0
    @objc dynamic var amountTicketGo: Int = 0
    @objc dynamic var amountTicketBack: Int = 0
    @objc dynamic var contactEmail: String = ""
    @objc dynamic var contactPhone: String = ""
    @objc dynamic var reservedGo = false
    @objc dynamic var reservedBack = false
    
    @objc dynamic var dateGo: String = ""
    @objc dynamic var dateBack: String = ""
    @objc dynamic var dateObjGo = Date()
    @objc dynamic var dateObjReturning = Date()
    
    func getTotalValue() -> Int {
        if QiwiOrder.isClickBusIdaEVolta() {
            return (ticketPriceGo * amountTicketGo) + (ticketPriceBack * amountTicketBack)
        } else {
            return ticketPriceGo * amountTicketGo
        }
    }
    
    func getTotalValueForDestiny() -> Int {
        return ticketPriceGo * amountTicketGo
    }
    
    func getTotalValueForReturning() -> Int {
        return ticketPriceBack * amountTicketBack
    }
}
