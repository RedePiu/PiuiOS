//
//  PIXRequestDAO.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 19/02/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation

class PIXRequestDAO: BaseDAO {

    typealias T = PIXRequest
    
    func get(name: String) -> T {
        let items = DBManager.shared.getList(T.self, query: "name = \(name)")
        return !items.isEmpty ? items.first! : PIXRequest()
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
