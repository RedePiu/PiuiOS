//
//  TaxesDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/09/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class TaxesDAO: BaseDAO {
    
    typealias T = Tax
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func get(prvid: Int) -> T {
        let list = DBManager.shared.getList(T.self, query: "prvId = \(prvid)")
        let tax = list.isEmpty ? Tax() : list.first!
        return tax
    }
    
    func getAll(prvid: Int) -> [T] {
        let list = DBManager.shared.getList(T.self, query: "prvId = \(prvid)")
        return list
    }
    
    func update(with object: T) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
    }
    
    func insert(with object: T) {
        DBManager.shared.incrementTax(object: object)
    }
    
    func insert(with object: [T]) {
        DBManager.shared.incrementTaxes(taxes: object)
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
