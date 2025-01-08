//
//  PaymentTypeLimitPrvIdDAO.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 20/09/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

class PaymentTypeLimitPrvIdDAO: BaseDAO {

    typealias T = PaymentTypeLimitPrvId
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func getAll(prvid: Int) -> [T] {
        return DBManager.shared.getList(T.self, query: "prvId = \(prvid)")
    }
    
    func get(prvid: Int, paymentId: Int) -> T {
        //parei aqui, talvez tenha que criar novo tipo pagamento 14. Pix v2
        let items = DBManager.shared.getList(T.self, query: "prvId = \(prvid) and paymentType = \(paymentId)")
        if !items.isEmpty {
            return items.first!
        }
        return T()
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
