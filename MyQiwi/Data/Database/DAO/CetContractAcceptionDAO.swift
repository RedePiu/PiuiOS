//
//  CetContractAcceptionDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 01/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class CetContractAcceptionDAO: BaseDAO {
    
    typealias T = CETContractAcception
    
    func get(userId: Int) -> T {
        let items = DBManager.shared.getList(T.self, query: "userId = \(userId)")
        return !items.isEmpty ? items.first! : CETContractAcception()
    }
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
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
