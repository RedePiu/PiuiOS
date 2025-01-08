//
//  TransportCardDAO.swift
//  MyQiwi
//
//  Created by Ailton on 14/11/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class TransportCardDAO: BaseDAO {
    
    typealias T = TransportCard
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func getAllByType(type: Int) -> [T] {
        let items = DBManager.shared.getList(T.self, query: "type = \(type)")
        return items
    }
    
    func getAllBilheteUnico(type: Int) -> [T] {
        let items = DBManager.shared.getList(T.self, query: "type = 0 OR type = 6 OR type = \(type)")
        return items
    }
    
    func get(cardNumber: String) -> T {
        let items = DBManager.shared.getList(T.self, query: "number = \"\(cardNumber)\"")
        return !items.isEmpty ? items.first! : TransportCard()
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
        DBManager.shared.deleteWithStringPk(T.self, filter: "number", filterArg: object.number)
    }
    
    func delete(with object: [T]) {
        DBManager.shared.deleteAll(T.self, object: object)
    }
    
    func deleteAll() {
        self.delete(with: getAll())
    }
}
