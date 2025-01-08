//
//  CouponProductDAO.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 14/04/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import Foundation

class CouponProductDAO: BaseDAO {
    
    typealias T = CouponProduct
    
//    func get(primaryKey: Int) -> T {
//        let items = DBManager.shared.getList(T.self, query: "id = \(primaryKey)")
//        return !items.isEmpty ? items.first! : Bank()
//    }
    
    func getAll(couponCode: String) -> [T] {
        return DBManager.shared.getList(T.self, query: "couponCode = \"\(couponCode)\"")
    }
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func update(with object: T) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
    }
    
    func insert(with object: T) {
        DBManager.shared.incrementCouponProduct(object: object)
    }
    
    func insert(with object: [T]) {
        for t in object {
            insert(with: t)
        }
    }
    
    func delete(with object: T) {
        DBManager.shared.deleteWith(T.self, object: object)
    }
    
    func delete(with object: [T]) {
        DBManager.shared.deleteAll(T.self, object: object)
    }
    
    func deleteAll() {
        self.delete(with: getAll())
    }
    
    func deleteAll(couponCode: String) {
        self.delete(with: getAll(couponCode: couponCode))
    }
}
