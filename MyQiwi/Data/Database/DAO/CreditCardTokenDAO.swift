//
//  CreditCardTokenDAO.swift
//  MyQiwi
//
//  Created by Ailton on 26/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation

class CreditCardTokenDAO : BaseDAO {
    typealias T = CreditCardToken
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func get(tokenId: Int) -> T {
        return DBManager.shared.get(T.self, query: "tokenId = \(tokenId)")
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
