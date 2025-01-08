//
//  MenuItemDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/09/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class MenuItemDAO: BaseDAO {
    
    typealias T = MenuItem
    
    func getAll() -> [T] {
            return DBManager.shared.getList(T.self)
    }
    
    func getMenu(action: Int) -> T {
        return DBManager.shared.get(T.self, query: "action = \(action)")
    }
    
    func getAllFromDad(dadId: Int, name: String = "") -> [T] {
        
        if name != "" {
            let predicate = NSPredicate(format: "desc CONTAINS[c] %@ AND dadId = %d AND order > 0", name, dadId)
            return DBManager.shared.getList(T.self, query: predicate, orderBy: "order")
        }
        else {
            return DBManager.shared.getList(T.self, query: "dadId = \(dadId) AND order > 0", orderBy: "order")
        }
    }
    
    func getAllFromDadTop(dadId: Int) -> [T] {
        return DBManager.shared.getList(T.self, query: "order < 0", orderBy: "order")
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
