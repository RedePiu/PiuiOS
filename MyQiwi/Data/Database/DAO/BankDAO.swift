//
//  BankDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/09/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class BankDAO: BaseDAO {

    typealias T = Bank
    
    func get(primaryKey: Int) -> T {
        let items = DBManager.shared.getList(T.self, query: "id = \(primaryKey)")
        return !items.isEmpty ? items.first! : Bank()
    }
    
    func getAll() -> [T] {
        var banks = DBManager.shared.getList(T.self)
        if banks.isEmpty { return banks }
        
        banks.removeAll{ $0.id == ActionFinder.Bank.PIX }
        return banks
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
