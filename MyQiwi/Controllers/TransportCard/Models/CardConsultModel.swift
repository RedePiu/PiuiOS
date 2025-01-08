import ObjectMapper
import UIKit

class CardConsultModel: BasePojo, Decodable {
    var idEmissor: Int
    var cpf: String
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idEmissor <- map["id_emissor"]
        cpf <- map["cpf"]
    }
    
    convenience init(idEmissor: Int, cpf: String) {
        self.init()
        self.idEmissor = idEmissor
        self.cpf = cpf
    }
}
