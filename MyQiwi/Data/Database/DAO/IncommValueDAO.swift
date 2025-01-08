//
//  IncommValueDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/12/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class IncommValueDAO : BaseDAO {
    
    typealias T = IncommValue
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func get(prvid: Int) -> T {
        let list = DBManager.shared.getList(T.self, query: "prvId = \(prvid)")
        let value = list.isEmpty ? IncommValue() : list.first!
        return value
    }
    
    func get(prvid: Int) -> [T] {
        return DBManager.shared.getList(T.self, query: "prvId = \(prvid)", orderBy: "maxValue")
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
