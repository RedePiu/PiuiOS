//
//  OperatorValuesDataHandler.swift
//  MyQiwi
//
//  Created by Ailton on 19/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class OperatorValuesDataHandler: BaseDataHandler<OperatorValue> {
    
    lazy var mPhoneRechargeRN = PhoneRechargeRN(delegate: self)
    var delegate: BaseDelegate?
    
    init(delegate: BaseDelegate?) {
        self.delegate = delegate
    }
    
    func fillPhoneRechargeValues(ddd: String, operatorId: Int) -> Void {
        mPhoneRechargeRN.getAvailablesValues(ddd: ddd, operatorId: operatorId)
    }
}

// MARK: Delegate Base
extension OperatorValuesDataHandler: BaseDelegate {
    
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        //If its telling to finish
        if (fromClass == PhoneRechargeRN.self) {
            if (param == Param.Contact.PHONE_RECHARGE_AVAILABLE_VALUES_RESPONSE) {
                if (result) {
                    self.arrItems = (object as! [OperatorValue])
                }
                self.delegate?.onReceiveData(fromClass: OperatorValuesDataHandler.self, param: param, result: result, object: object)
            }
        }
    }
}
