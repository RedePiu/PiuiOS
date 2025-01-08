//
//  DBManager.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 18/09/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class DBManager: NSObject {

    // MARK: Properties
    static let shared = DBManager()
    fileprivate var realm: Realm?
    static let VERSION: UInt64 = 59

    // MARK: Init
    private override init() {
        super.init()
        self.initRealm()
    }

    private func initRealm() {

        do {

            let config = DBManager.customConfigRealm()
            Realm.Configuration.defaultConfiguration = config
            realm = try Realm(configuration: config)
        } catch {
            Log.print("ERRO AO INICIAR REALM: \(error.localizedDescription)")
        }
    }

    func get<T:Object>(_ type: T.Type, primaryKey: Int) -> T {
        var obj = T()

        self.realm = try? Realm()
        try? obj = Realm().object(ofType: type, forPrimaryKey: primaryKey)!

        //try? obj = Realm().objects(T.self).filter(query)

        return obj
    }

    func incrementID<T:Object>(_ type: T.Type, primaryKeyName: String) -> Int {
        self.realm = try? Realm()
        return (realm?.objects(type).max(ofProperty: primaryKeyName) as Int? ?? 0) + 1
    }

    func getList<T:Object>(_ type: T.Type) -> [T] {
        var items: [T] = []

        self.realm = try? Realm()
        try? Realm().objects(T.self).forEach { items.append($0) }

        return items
    }

    func getList<T:Object>(_ type: T.Type, query: String) -> [T] {
        var items: [T] = []

        self.realm = try? Realm()
        try? Realm().objects(T.self).filter(query).forEach { items.append($0) }

        return items
    }
    
    func getList<T:Object>(_ type: T.Type, query: String, orderBy: String, ascending: Bool = true) -> [T] {
        var items: [T] = []

        self.realm = try? Realm()
        try? Realm().objects(T.self).filter(query).sorted(byKeyPath: orderBy, ascending: ascending).forEach { items.append($0) }

        return items
    }
    
    func getList<T:Object>(_ type: T.Type, query: NSPredicate, orderBy: String, ascending: Bool = true) -> [T] {
        var items: [T] = []

        self.realm = try? Realm()
        try? Realm().objects(T.self).filter(query).sorted(byKeyPath: orderBy, ascending: ascending).forEach { items.append($0) }

        return items
    }

    func get<T:Object>(_ type: T.Type, query: String) -> T {
        var items = T()

        self.realm = try? Realm()
        try? Realm().objects(T.self).filter(query).forEach { items = $0 }

        return items
    }

    func saveWith<T:Object>(_ type: T.Type, object: T, update: Bool) {

        self.realm = try? Realm()

        do {
            try realm?.write {
                self.realm?.add(object, update: update ? .all : .error)
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }

    func incrementPassengerClickbus(object: PassengerClickBus) {
        self.realm = try? Realm()
        
        do {
            try self.realm?.write {
                let id = (self.realm?.objects(
                    PassengerClickBus.self
                ).max(ofProperty: "id") as Int? ?? 0) + 1
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }
    
    func incrementCouponProduct(object: CouponProduct) {
        self.realm = try? Realm()

        do {
            try self.realm?.write {
                let id = (self.realm?.objects(CouponProduct.self).max(ofProperty: "id") as Int? ?? 0) + 1

                object.id = id
                self.realm?.add(object, update: .all)
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }
    
    func incrementTax(object: Tax) {
        self.realm = try? Realm()

        do {
            try self.realm?.write {
                let id = (self.realm?.objects(Tax.self).max(ofProperty: "id") as Int? ?? 0) + 1

                object.id = id
                self.realm?.add(object, update: .all)
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }

    func incrementTaxes(taxes: [Tax]) {
        self.realm = try? Realm()

        do {
            try self.realm?.write {
                var id = 0

                for tax in taxes {
                    id = (self.realm?.objects(Tax.self).max(ofProperty: "id") as Int? ?? 0) + 1
                    tax.id = id

                    self.realm?.add(tax, update: .all)
                }
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }

    func saveWith<T:Object>(_ type: T.Type, object: [T], update: Bool) {

        self.realm = try? Realm()

        do {
            try self.realm?.write {
                self.realm?.add(object, update: update ? .all : .error)
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }

    func deleteWithStringPk<T:Object>(_ type: T.Type, filter: String, filterArg: String) {

        self.realm = try? Realm()

        do {
            try self.realm?.write {
                self.realm?.delete((self.realm?.objects(T.self).filter("\(filter)=%@",filterArg))!)
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }

    func deleteWith<T:Object>(_ type: T.Type, object: T) {

        self.realm = try? Realm()

        do {
            try self.realm?.write {
                self.realm?.delete(object)
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }

    func deleteAll<T:Object>(_ type: T.Type, object: [T]) {

        self.realm = try? Realm()

        do {
            try self.realm?.write {
                self.realm?.delete(object)
            }
        } catch {
            Log.print(error.localizedDescription)
        }
    }

    // MARK: Delete all content database
    func deleteCurrentData() {

        DBManager.deleteFolderAttachments()
        DBManager().deleteAllDatabase()
    }

    func deleteAllDatabase()  {

        self.realm = try? Realm()

        do {

            try self.realm?.write {
                self.realm?.deleteAll()
            }

        } catch {
            Log.print("ERRO AO APAGAR TUDO: \(error.localizedDescription)")
        }
    }
}

extension DBManager {

    // MARK: Config with EncryptionKey
    static func customConfigRealm() -> Realm.Configuration {

        let nameDB = Realm.Configuration.defaultConfiguration.fileURL!.deletingLastPathComponent().appendingPathComponent("myqiwi.realm")

        var config = Realm.Configuration()
        config.fileURL = nameDB
        config.schemaVersion = DBManager.VERSION
        config.deleteRealmIfMigrationNeeded = true
        config.migrationBlock = { migration, oldSchemaVersion in
        }
        return config
    }
}

extension DBManager {

    // MARK: Delete DB Files
    static func deleteDBFromDisk() {

        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                Log.print(error.localizedDescription)
            }
        }
    }

    static func deleteFolderAttachments() {

        do {
            let url = URL(fileURLWithPath: pathDiretorio())
            if #available(iOS 11.0, *) {
                try FileManager.default.trashItem(at: url, resultingItemURL: nil)
            } else {
                try FileManager.default.removeItem(atPath: pathDiretorio())
            }
        } catch {
            Log.print("\(error.localizedDescription)")
        }
    }

    static func pathDiretorio() -> String {

        // obtem o diretorio
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        let pathFile = documentsDirectory.appending("/qiwi/")
        return pathFile
    }
}
