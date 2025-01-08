//
//  OrderDataHandler.swift
//  MyQiwi
//
//  Created by ailton on 22/12/17.
//  Copyright © 2017 Qiwi. All rights reserved.
//

import Foundation

class OrderDataHandler: BaseDataHandler<Order> {
    
    lazy var mOrderRN = OrderRN(delegate: self)
    var delegate: BaseDelegate?
    var orderFilters = OrderFilters()
    var lastStartFrom = 0
    
    init(delegate: BaseDelegate) {
        self.delegate = delegate
    }
    
    public func fillOrderList(startFrom: Int) {
        self.lastStartFrom = startFrom
        mOrderRN.getOrderList(startFrom: startFrom)
    }
}

extension OrderDataHandler: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        if result {
            //se for 0 reseta o array
            if lastStartFrom == 0 {
                self.arrItems = [Order]()
            }
            
            self.arrItems.append(contentsOf: object as! [Order])
            self.arrItems = self.orderFilters.filterOrderList(orders: self.arrItems)
            
            delegate?.onReceiveData(fromClass: OrderDataHandler.self, param: Param.Contact.ORDERS_ORDER_LIST_RESPONSE,
                                    result: result && !self.arrItems.isEmpty, object: nil)
        }
    }
}
