//
//  AddressCET.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class AddressCET: BasePojo {
    
    @objc dynamic var faceQuadId: Int = 0
    @objc dynamic var areaId: Int = 0
    @objc dynamic var areaNome: String = ""
    @objc dynamic var sector: String = ""
    @objc dynamic var face: String = ""
    @objc dynamic var local: String = ""
    @objc dynamic var corredor: String = ""
    @objc dynamic var side: String = ""
    @objc dynamic var autoSpaceAmount: Int = 0
    @objc dynamic var truckSpaceAmount: Int = 0
    @objc dynamic var charteredSpaceAmount: Int = 0
    @objc dynamic var elderSpaceAmount: Int = 0
    @objc dynamic var deficientSpaceAmount: Int = 0
    var rules = [RuleCET]()
    var cordinates = [CoordinateCET]()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        faceQuadId <- map["Id_Face_quad"]
        areaId <- map["Id_Area"]
        areaNome <- map["Nome_Area"]
        sector <- map["Setor"]
        face <- map["Face"]
        local <- map["Local"]
        corredor <- map["Corredor"]
        side <- map["Lado"]
        autoSpaceAmount <- map["Qtd_Vaga_Auto"]
        truckSpaceAmount <- map["Qtd_Vaga_Caminhao"]
        charteredSpaceAmount <- map["Qtd_Vaga_Fretado"]
        elderSpaceAmount <- map["Qtd_Vaga_Idoso"]
        deficientSpaceAmount <- map["Qtd_Vaga_Deficiente"]
        rules <- map["Regras"]
        cordinates <- map["Coordenadas"]
    }
    
//    func generateJsonBody() -> Data {
//
//        // Manual Generate Data -> Server parsing order keys
//        // For objects lists
//        // ServiceBody<InitilizationBody>
//
//        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
//    }
//
//    //{"cod_ativacao":"342245","id_cadastro":9637}
//    func generateJsonBodyAsString() -> String {
//
//        // Extract optional
//        let bodyString = "{\"cod_ativacao\":\"\(self.car)\",\"id_cadastro\":\(self.car)}"
//        return bodyString
//    }
}
