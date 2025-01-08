//
//  RVDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 20/09/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

class RVDAO: BaseDAO  {
    typealias T = RvValue
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func get(prvid: Int) -> T {
        let list = DBManager.shared.getList(T.self, query: "prvid = \(prvid)")
        let value = list.isEmpty ? RvValue() : list.first!
        return value
    }
    
    func getList(prvid: Int) -> [T] {
        return DBManager.shared.getList(T.self, query: "prvid = \(prvid)")
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
