//
//  GetTaxasDAO.swift
//  MyQiwi
//
//  Created by Daniel Catini on 18/04/24.
//  Copyright © 2024 Qiwi. All rights reserved.
//

import Foundation

class GetTaxasDAO: BaseDAO  {
   typealias T = GetTaxasResponse
   
   func getAll() -> [T] {
       return DBManager.shared.getList(T.self)
   }
   
   /*
   func getByPrv(prvid: Int) -> T {
       return DBManager.shared.get(T.self, query: "prvId = \(prvid)")
   }
   
   func get(prvid: Int) -> T {
       let list = DBManager.shared.getList(T.self, query: "prvId = \(prvid)")
       let value = list.isEmpty ? TaxaCardResponse() : list.first!
       return value
   }
    */
   
   func getList(prvid: Int) -> [T] {
       return DBManager.shared.getList(T.self, query: "prvId = \(prvid)")
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
