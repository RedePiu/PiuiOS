//
//  ChargeSequenceBase.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 11/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class ChargeSequenceBase {
    
    var date : String
    var type : String
    var productName : String
    var selectedMenu : MenuItem
    var qiwiPass : String
    var checkoutBody : CheckoutBody
    
    init() {
        self.date = ""
        self.type = ""
        self.productName = ""
        self.selectedMenu = .init()
        self.qiwiPass = ""
        self.checkoutBody = .init()
    }
}
