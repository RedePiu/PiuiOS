import UIKit

class CardTypeModel: BasePojo, Codable {
    let idTipoFormularioCarga: Int
    let nome: String
    let codCarga: String
    
    enum CodingKeys: String, CodingKey {
        case idTipoFormularioCarga = "Id_Tipo_Formulario_Carga"
        case nome = "Nome"
        case codCarga = "Cod_Carga"
    }
}
