//
//  PaymentTypeDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/09/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class PaymentTypeDAO: BaseDAO {
    
    typealias T = PaymentType
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func getByType(idSlipType: Int) -> T {
        return DBManager.shared.get(T.self, query: "idSlipType = \(idSlipType)")
    }
    
    func update(with object: T) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
    }
    
    func insert(with object: T) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
    }
    
    func insert(with object: [T]) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
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
}
