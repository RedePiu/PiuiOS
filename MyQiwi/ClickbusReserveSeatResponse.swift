//
//  ClickbusReserveSeatResponse.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/12/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import ObjectMapper

class ClickbusReserveSeatResponse : BasePojo {
    
    @objc dynamic var menssageError : String = ""
    @objc dynamic var seatIdResponse : String = ""
    @objc dynamic var expiretAt : String = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        menssageError <- map["MensagemErroResposta"]
        seatIdResponse <- map["SeatIdResposta"]
        expiretAt <- map["ExpireAt"]
    }
}
