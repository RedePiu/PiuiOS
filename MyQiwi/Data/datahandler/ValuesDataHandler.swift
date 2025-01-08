//
//  ValuesDataHandler.swift
//  MyQiwi
//
//  Created by ailton on 28/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation

public class ValuesDataHandler: BaseDataHandler<MenuItem> {
    
    lazy var mPhoneRechargeRN = PhoneRechargeRN(delegate: self)
    
    public func fillPhoneRechargeValues(op: Operator) -> Void {
        mPhoneRechargeRN.getAvailablesValues(op: op)
    }
}

// MARK: Delegate Base
extension ValuesDataHandler: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        //If its telling to finish
        if (fromClass == PhoneRechargeRN.self) {
            if (param == Param.Contact.PHONE_RECHARGE_AVAILABLE_VALUES_RESPONSE) {
                self.arrItems = (object as! [MenuItem])
            }
        }
    }
}
