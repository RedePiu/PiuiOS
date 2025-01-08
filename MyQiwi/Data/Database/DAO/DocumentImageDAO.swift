//
//  DocumentImageDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 08/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class DocumentImageDAO : BaseDAO {
    
    typealias T = DocumentImage
    
    func get(primaryKey: Int) -> T {
        let items = DBManager.shared.getList(T.self, query: "id = \(primaryKey)")
        return !items.isEmpty ? items.first! : DocumentImage()
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
