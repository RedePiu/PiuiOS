import UIKit

struct GetFormsModel: Decodable {
    var cpf: String
    var id_emissor: Int
}

extension GetFormsModel {
    func generateJsonBody() -> Data {
        return RestHelper.jsonStringToData(jsonString: self.generateJsonBodyAsString())
    }
    
    func generateJsonBodyAsString() -> String {
        return "{\"cpf\":\"\(self.cpf)\",\"id_emissor\":\(self.id_emissor)}"
    }
}
