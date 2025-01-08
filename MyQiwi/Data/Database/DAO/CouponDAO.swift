//
//  CouponDAO.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class CouponDAO: BaseDAO {
    
    typealias T = Coupon
    var couponProductDAO = CouponProductDAO()
    
    func get(code: String) -> T {
        let items = DBManager.shared.getList(T.self, query: "code = \"\(code)\"")
        return !items.isEmpty ? items.first! : Coupon()
    }
    
    func getAll() -> [T] {
        let list = DBManager.shared.getList(T.self)
        
        if !list.isEmpty {
            for coupon in list {
                coupon.products = couponProductDAO.getAll(couponCode: coupon.code)
            }
        }
        
        return list
    }
    
    func insert(with object: T) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
        
        for product in object.products {
            product.couponCode = object.code
        }
        
        self.couponProductDAO.insert(with: object.products)
    }
    
    func insert(with object: [T]) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
        
        for coupon in object {
            for product in coupon.products {
                product.couponCode = coupon.code
            }
            
            self.couponProductDAO.insert(with: coupon.products)
        }
    }
    
    func update(with object: Coupon) {
        
    }
    
    func delete(coupons: [RequestCoupons]) {
        
        var coupon: Coupon
        
        for c in coupons {
            coupon = get(code: c.code)
            
            if !coupon.code.isEmpty {
                delete(with: coupon)
            }
        }
    }
    
    func delete(with object: T) {
        self.couponProductDAO.deleteAll(couponCode: object.code)
        DBManager.shared.deleteWith(T.self, object: object)
    }
    
    func delete(with object: [T]) {
        
        for obj in object {
            self.couponProductDAO.deleteAll(couponCode: obj.code)
        }
        
        DBManager.shared.deleteAll(T.self, object: object)
    }
    
    func deleteAll() {
        self.delete(with: getAll())
    }
}
