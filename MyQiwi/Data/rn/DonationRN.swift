//
//  DonationRN.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 08/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation

class DonationRN: BaseRN {

    //UserDefaults.standard
    func getValueList() -> [Int] {
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
