//
//  SerasaValueDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class SerasaValueDAO : BaseDAO {
    
    typealias T = SerasaValue
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func get(prvid: Int) -> T {
        let list = DBManager.shared.getList(T.self, query: "prvId = \(prvid)")
        let tax = list.isEmpty ? SerasaValue() : list.first!
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
