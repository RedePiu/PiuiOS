import ObjectMapper
import UIKit

class GetEmissorModel: BasePojo, Decodable {
    var idEmissor: Int
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        idEmissor <- map["id_emissor"]
    }
    
    convenience init(idEmissor: Int) {
        self.init()
        self.idEmissor = idEmissor
    }
}
