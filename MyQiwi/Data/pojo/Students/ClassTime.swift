//
//  ClassTime.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 26/08/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import ObjectMapper

class ClassTime : BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var idTimeType: Int = 0
    @objc dynamic var startTimeMorning: String = ""
    @objc dynamic var endTimeMorning: String = ""
    @objc dynamic var startTimeAfternoon: String = ""
    @objc dynamic var endTimeAfternoon: String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id <- map["id"]
        idTimeType <- map["IdTipoHorarioProdata"]
        startTimeMorning <- map["HoraInicialManha"]
        endTimeMorning <- map["HoraFinalManha"]
        startTimeAfternoon <- map["HoraInicialTarde"]
        endTimeAfternoon <- map["HoraFinalTarde"]
    }
}
