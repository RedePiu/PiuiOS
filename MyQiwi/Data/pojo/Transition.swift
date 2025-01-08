//
//  Transition.swift
//  MyQiwi
//
//  Created by Ailton on 13/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import ObjectMapper
import CoreLocation

class Transition : BasePojo {
    
    @objc dynamic var transitionValue : Int = 0
    @objc dynamic var value : Int = 0
    @objc dynamic var prvId : Int = 0
    @objc dynamic var qiwiBalance : QiwiBalanceRequest?
    @objc dynamic var prePago : QiwiBalanceRequest?
    @objc dynamic var token : Token?
    @objc dynamic var bankRequest : BankRequest?
    @objc dynamic var pix : PIXRequest?
    @objc dynamic var pix_v2 : PIXV2Request?
    var coupons : [RequestCoupons]?
    @objc dynamic var userId : Int = Int(UserDefaults.standard.integer(forKey: PrefsKeys.PREFS_USER_ID))
    @objc dynamic var latitude : Double = 0
    @objc dynamic var longitude : Double = 0
    @objc dynamic var phoneReceipt : String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        transitionValue <- map["valorTransacao"]
        value <- map["valor"]
        prvId <- map["prvID"]
        qiwiBalance <- map["qiwi"]
        prePago <- map["prePago"]
        token <- map["token"]
        bankRequest <- map["transferencia"]
        pix <- map["pix"]
        pix_v2 <- map["pix_v2"]
        userId <- map["id_usuario_mobile"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        phoneReceipt <- map["telefone_recibo"]
        coupons <- map["cupons"]
    }
    
    public func updateLocation() {
        self.latitude = CLLocation().coordinate.latitude
        self.longitude = CLLocation().coordinate.longitude
    }
}
