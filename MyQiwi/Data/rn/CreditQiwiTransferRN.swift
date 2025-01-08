//
//  CreditQiwiTransferRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 17/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class CreditQiwiTransferRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    static func getMinValue() -> Int {
        return 100
    }
    
    static func getMaxValue() -> Int {
        return 50000
    }
    
    func getValueList(balance: Int) -> [Int] {
        
        var list: [Int] = []
        
        list.append(500)
        list.append(1000)
        list.append(3000)
        list.append(5000)
        list.append(10000)
        list.append(20000)
        list.append(-1)
        return list
    }
}
