import ObjectMapper
import UIKit

class UpdateFormModel: BasePojo {
    @objc dynamic var id_formulario: Int = 0
    var campos: [CampoCreateForm]?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override func mapping(map: Map) {
        id_formulario <- map["id_formulario"]
        campos <- map["campos"]
    }
    
    convenience init(id_formulario: Int, campos: [CampoCreateForm]) {
        self.init()
        
        self.id_formulario = id_formulario
        self.campos = campos
        
    }
}
