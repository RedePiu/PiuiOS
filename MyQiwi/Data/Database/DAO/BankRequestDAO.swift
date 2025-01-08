//
//  BankRequestDAO.swift
//  MyQiwi
//
//  Created by Ailton on 27/09/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class BankRequestDAO: BaseDAO {
    typealias T = BankRequest
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func getAllFromBank(bankId: Int) -> [T] {
        return DBManager.shared.getList(T.self, query: "bankId = \(bankId)")
    }
    
    func update(with object: T) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
    }
    
    func insert(with object: T) {
        DBManager.shared.saveWith(T.self, object: object, update: true)
    }
    
    func insert(with object: [T]) {
        for i in 0..<object.count {
            object[i].appId = i+1
        }
        
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
