import UIKit

struct ListItemsResponse: Decodable {
    var id_taxa: Int
    var id_prv: Int
    var valor_taxa: Double
    var valor_adicional: Double
    var nome: String
    var id_imagem: String
    var via: Int
    var fl_entrega: Bool
    var tipo_formulario: Int
    var campos: [CamposGetTaxasResponse]?
    
    enum CodingKeys: String, CodingKey {
        case id_taxa, id_prv, tipo_formulario, via
        case valor_taxa, valor_adicional
        case nome, id_imagem
        case fl_entrega
    }
}
