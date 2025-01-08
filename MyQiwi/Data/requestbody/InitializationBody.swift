//
//  InitializationBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

class InitializationBody: BasePojo {

    @objc dynamic var city: String = ""
    @objc dynamic var deviceToken: String = ""
    @objc dynamic var appVersion: String = Constants.version
    @objc dynamic var iosVersion: String = UIDevice.current.systemVersion
    @objc dynamic var latitude: Double = 0
    @objc dynamic var longitude: Double = 0
    @objc dynamic var terminalType: Int = 1
    @objc dynamic var idMobileApp: Int = 6

    required convenience init?(map: Map) {
        self.init()
    }

    override func mapping(map: Map) {
        iosVersion <- map["versao_so"]
        appVersion <- map["versao_app"]
        city <- map["municipio"]
        deviceToken <- map["device_token"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        terminalType <- map["id_tipo_terminal"]
        idMobileApp <- map["id_aplicacao_mobile"]
    }

    func generateJsonBody() -> Data {

        // Manual Generate Data -> Server parsing order keys
        // For objects lists
        // ServiceBody<InitilizationBody>

        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }

    func generateJsonBodyAsString() -> String {

        ////{"body":{"cpf":"43497458821","num_celular":"11988447064","id_usuario":-1}

        // Extract optional
//        let bodyString = "{\"versao_so\":\"\(bodyData.iosVersion)\",\"versao_app\":\"\(bodyData.appVersion)\",\"municipio\":\"\(bodyData.city)\",\"device_token\":\"\(bodyData.deviceToken)\"}"

        let bodyString = "{\"versao_so\":\"\(self.iosVersion)\",\"versao_app\":\"\(self.appVersion)\",\"municipio\":\"\(self.city)\",\"device_token\":\"\(self.deviceToken)\",\"id_aplicacao_mobile\":\(self.idMobileApp),\"latitude\":\"\(self.latitude)\",\"longitude\":\"\(self.longitude)\",\"id_tipo_terminal\":\(self.terminalType)}"

        return bodyString
    }
}
