//
//  ClickBusCityDAO.swift
//  MyQiwi
//
//  Created by Thyago on 18/11/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ClickBusCityDAO: BaseDAO {

    typealias T = ClickBusCity
    
    func get(primaryKey: Int) -> T {
        let items = DBManager.shared.getList(T.self, query: "id = \(primaryKey)")
        return !items.isEmpty ? items.first! : ClickBusCity()
    }
    
    func getAll(name: String) -> [T] {
        return DBManager.shared.getList(T.self, query: "name LIKE \"\(name)%\"")
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

