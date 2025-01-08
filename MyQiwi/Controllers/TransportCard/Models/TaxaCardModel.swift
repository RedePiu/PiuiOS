import UIKit

struct TaxaCardModel: Decodable {
    var cliente: String
    var cartao: String
    var codCarga: Int
    var tipo: MenuCardTypeResponse?
    
    enum CodingKeys: String, CodingKey {
        case cliente = "CLIENTE"
        case cartao = "CARTAO"
        case codCarga = "TIPO"
    }
}
