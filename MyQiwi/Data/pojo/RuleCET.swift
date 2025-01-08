//
//  RuleCET.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 01/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class RuleCET: BasePojo {
 
    @objc dynamic var ruleId: Int = 0
    @objc dynamic var cadTime: Int = 0
    @objc dynamic var startHour: String = ""
    @objc dynamic var endHour: String = ""
    @objc dynamic var startHourSaturday: String = ""
    @objc dynamic var endHourSaturday: String = ""
    @objc dynamic var startHourSunday: String = ""
    @objc dynamic var endHourSunday: String = ""
    @objc dynamic var startHourHolyday: String = ""
    @objc dynamic var endHourHolyday: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        ruleId <- map["Id_Regra_CET"]
        cadTime <- map["Tempo_Cad"]
        startHour <- map["Hora_Inicio"]
        endHour <- map["Hora_Fim"]
        startHourSaturday <- map["Hora_Inicio_Sabado"]
        endHourSaturday <- map["Hora_Fim_Sabado"]
        startHourSunday <- map["Hora_Inicio_Domingo"]
        endHourSunday <- map["Hora_Fim_Domingo"]
        startHourHolyday <- map["Hora_Inicio_Feriado"]
        endHourHolyday <- map["Hora_Fim_Feriado"]
    }
    
    convenience init(cadTime: Int) {
        self.init()
        
        self.cadTime = cadTime
    }
}
