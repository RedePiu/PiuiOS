//
//  OrderFilters.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 07/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class OrderFilters {

    // MARK: Variabless
    
    fileprivate var mCanceled: Bool = true
    fileprivate var mPendent: Bool = true
    fileprivate var mFinished: Bool = true
    
    // MARK: Init
    
    init(canceled: Bool, pendent: Bool, finished: Bool) {
        self.updateValues(canceled: canceled, pendent: pendent, finished: finished)
    }
    
    // MARK: Init
    
    init() {
    }
}

extension OrderFilters {
    
    // MARK: Methods
    
    func updateValues(canceled: Bool, pendent: Bool, finished: Bool) {
        mCanceled = canceled
        mPendent = pendent
        mFinished = finished
    }
    
    func canShowThisOrder(order: Order) -> Bool {
        
        if (mCanceled && mPendent && mFinished) {
            return true
        }
        
        let status = order.status
        
        if (status == .canceled && mCanceled) ||
            (status == .pendent && mPendent) ||
            (status == .finished && mFinished) {
            return true
        }
        
        return false
    }
    
    func filterOrderList(orders: [Order]) -> [Order] {
        
        if (mCanceled && mPendent && mFinished) {
            return orders
        }
        
        var filteredOrders: [Order] = []
        
        for order in orders {
            
            if (order.status == .canceled && mCanceled) ||
                (order.status == .pendent && mPendent) ||
                (order.status == .finished && mFinished) {
                
                filteredOrders.append(order)
            }
        }
        
        return filteredOrders
    }
    
    func getCurrentFilterDesc() -> String {
        
        return self.getCurrentFilterDesc(canceled: mCanceled, pendent: mPendent, finished: mFinished)
    }
    
    fileprivate func getCurrentFilterDesc(canceled: Bool, pendent: Bool, finished: Bool) -> String {
        
        if (canceled && pendent && finished) {
            return "order_searching_all".localized
        }
        
        var filters: [String] = []
        
        if finished {
            filters.append("order_filter_finished".localized)
        }
        
        if pendent {
            filters.append("order_filter_pendent".localized)
        }
        
        if canceled {
            filters.append("order_filter_canceled".localized)
        }
        
        var filtersString = ""
        
        if filters.count == 1 {
            filtersString = filters[0]
        }
        
        if filters.count == 2 {
            filtersString = String(format: "%@ e %@", filters[0], filters[1])
        }
        
        if filters.count == 3 {
            filtersString = String(format: "%@, %@ e %@", filters[0], filters[1], filters[2])
        }
        
        return "order_searching_showing".localized.replacingOccurrences(of: "{filter}", with: filtersString)
    }
}
