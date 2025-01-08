//
//  TaxesDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/09/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class NotificationsDAO: BaseDAO {
    
    typealias T = PushResponse
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func get(id: Int) -> T {
        let list = DBManager.shared.getList(T.self, query: "id = \(id)")
        let notification = list.isEmpty ? PushResponse() : list.first!
        return notification
    }
    
    func getAll(userId: Int) -> [T] {
        let list = DBManager.shared.getList(T.self, query: "userId = \(userId)")
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
}
