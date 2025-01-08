//
//  RvValue.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

//import RealmSwift
import ObjectMapper

class RvValue: BasePojo {

    @objc dynamic var prodCod: Int = 0
    @objc dynamic var prvid: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var maxValue: Double = 0
    @objc dynamic var minValue: Double = 0
    
    override public static func primaryKey() -> String? {
        return "prodCod"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public convenience init(rvToCopy: RvValue) {
        self.init()
        
        self.prvid = rvToCopy.prvid
        self.prodCod = rvToCopy.prodCod
        self.desc = rvToCopy.desc
        self.minValue = rvToCopy.minValue
        self.maxValue = rvToCopy.maxValue
    }
    
    public convenience init(rvToCopy: RvValue, value: Double) {
        self.init()
        
        self.prvid = rvToCopy.prvid
        self.prodCod = rvToCopy.prodCod
        self.desc = rvToCopy.desc
        self.minValue = value
        self.maxValue = value
    }
    
    public override func mapping(map: Map) {
        prodCod <- map["Codigo_Produto"]
        prvid <- map["PrvID"]
        desc <- map["Descricao"]
        maxValue <- map["Valor_Maximo"]
        minValue <- map["Valor_Minimo"]
    }
}
