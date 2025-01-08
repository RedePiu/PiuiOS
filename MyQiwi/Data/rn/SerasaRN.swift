//
//  SerasaRN.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class SerasaRN: BaseRN {
    
    override init(delegate: BaseDelegate?) {
        super.init(delegate: delegate)
    }
    
    func getSerasaValue(prvId: Int) -> SerasaValue {
        let serasaValue = SerasaValueDAO().get(prvid: prvId)
        return serasaValue
    }
}
