
class CamposFormDAO: BaseDAO  {
    typealias T = CampoFormResponse
    
    func getAll() -> [T] {
        return DBManager.shared.getList(T.self)
    }
    
    func getList(id: Int) -> [T] {
        return DBManager.shared.getList(T.self, query: "Id = \(id)")
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

