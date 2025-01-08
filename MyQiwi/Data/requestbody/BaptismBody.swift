//
//  BaptismBody.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 16/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper

@objc
class BaptismBody: BasePojo {

    @objc dynamic var city: String = "São Paulo"
    @objc dynamic var appVersion: String = Constants.version
    @objc dynamic var iosVersion: String = UIDevice.current.systemVersion
    @objc dynamic var operationalSystem: String = UIDevice.current.systemName.lowercased()
    @objc dynamic var facturer: String = "Apple".lowercased()
    @objc dynamic var deviceModel: String = DeviceInformation.deviceTypeModelName().lowercased()
    var imeiList: [String] = [UIDevice.current.identifierForVendor?.uuidString.lowercased() ?? ""]
    var b: String = ""
    @objc dynamic var iosID: String = UIDevice.current.identifierForVendor?.uuidString.lowercased() ?? ""
    @objc dynamic var userType: Int = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        city <- map["cidade"]
        appVersion  <- map["versao_app"]
        iosVersion  <- map["versao_so"]
        operationalSystem  <- map["sistema_operacional"]
        facturer  <- map["fabricante"]
        deviceModel  <- map["modelo_aparelho"]
        imeiList  <- map["imei"]
        b  <- map["b"]
        iosID  <- map["androidid"]
        userType  <- map["tipo_terminal"]
    }
}
