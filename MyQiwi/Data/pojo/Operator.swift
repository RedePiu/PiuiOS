//
//  Operator.swift
//  MyQiwi
//
//  Created by ailton on 28/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import ObjectMapper
//import RealmSwift

public class Operator: BasePojo {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var prvId: Int = 0
    @objc dynamic var imagePath: String = ""
    
    override public static func primaryKey() -> String? {
        return "name"
    }
    
    public required convenience init?(map: Map) {
        self.init()
    }
    
    public override func mapping(map: Map) {
        id <- map["OperadoraID"]
        name <- map["NomeOperadora"]
        prvId <- map["OSMPProviderID"]
        imagePath <- map["path_imagem"]
    }
    
    convenience init(id: Int, name: String, image: String) {
        self.init()
        
        self.id = id
        self.name = name
        self.imagePath = image
    }
    
    convenience init(name: String, image: String) {
        self.init()
        
        self.name = name
        self.imagePath = image
    }
    
    func getSampleName() -> String {
        return Operator.getOperatorSampleName(operatorName: self.name)
    }
    
    static func getOperatorSampleName(operatorName: String) -> String {
        if (operatorName.isEmpty) {
            return ""
        }
        
        let lowerName = operatorName.lowercased()
        if (lowerName.contains("claro")) {
            return "claro"
        }
        
        if (lowerName.contains("tim")) {
            return "tim"
        }
        
        if (lowerName.contains("vivo")) {
            return "vivo"
        }
        
        if (lowerName.contains("oi")) {
            return "oi"
        }
        
        if (lowerName.contains("nextel")) {
            return "nextel"
        }
        
        return ""
    }
}
