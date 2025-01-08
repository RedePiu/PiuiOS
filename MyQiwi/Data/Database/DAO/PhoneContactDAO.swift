//
//  PhoneContactDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 13/08/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
//import RealmSwift

class PhoneContactDAO: BaseDAO {
    
    typealias T = PhoneContact
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func getAllNational() -> [T] {
        return DBManager.shared.getList(T.self, query: "ddd <> \"0\"")
    }
    
    func getAllInternational() -> [T] {
        return DBManager.shared.getList(T.self, query: "ddd = \"0\"")
    }
    
    func get(serverPk: Int) -> T {
        return DBManager.shared.get(T.self, query: "serverpk = \(serverPk)")
    }
    
    func get(number: String) -> T {
        return DBManager.shared.get(T.self, query: "number = \"\(number)\"")
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
    
    func deleteWithField(number: String) {
        DBManager.shared.deleteWithStringPk(T.self, filter: "number", filterArg: number)
    }
    
    func deleteAll() {
        self.delete(with: getAll())
    }
}

