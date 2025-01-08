import ObjectMapper
import UIKit

class CampoFormResponseModel: BasePojo, Decodable {
    var id: Int
    var id_campo: Int
    var valor: String
    var fl_validado: Bool
}

class GetFormsResponseModel: BasePojo, Decodable {
    var id_formulario: Int
    var id_emissor: Int
    var id_status: Int
    var status: String
    var id_tipo_carga: Int
    var via: Int
    var fl_dependente: Bool
    var motivo: String
    var campos: [CampoFormResponseModel]
}
