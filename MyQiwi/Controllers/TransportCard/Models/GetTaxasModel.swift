import UIKit

class GetTaxasModel: BasePojo, Decodable {
    var idTaxa: Int?
    var idPrv: Int?
    var valorTaxa: Double?
    var valorAdicional: Double?
    var nome: String?
    var idImagem: String?
    var via: Int?
    var flEntrega: Bool?
    var tipFormulario: Int?
    var campos: [CamposGetTaxasResponse]?
    
    enum CodingKeys: String, CodingKey {
        case idTaxa = "id_taxa"
        case idPrv = "id_prv"
        case valorTaxa = "valor_taxa"
        case valorAdicional = "valor_adicional"
        case idImagem = "id_imagem"
        case flEntrega = "fl_entrega"
        case tipFormulario = "tipo_formulario"
    }
}
