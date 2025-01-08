//
//  PassengerClickBusDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import Foundation

class PassengerClickBusDAO: BaseDAO {
    
    typealias T = PassengerClickBus
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }

    func update(with object: T) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
    }
    
    func insert(with object: T) {
        DBManager.shared.incrementPassengerClickbus(object: object)
    }
    
    func insert(with object: [T]) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
    }
    
    func deleteWithDocument(document: String) {
           DBManager.shared.deleteWithStringPk(T.self, filter: "document", filterArg: document)
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
