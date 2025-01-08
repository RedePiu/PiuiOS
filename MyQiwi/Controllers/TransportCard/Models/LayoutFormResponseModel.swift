import UIKit

struct LayoutFormResponseModel: Decodable {
    var Id: Int
    var Id_Formulario_Tipo_Cartao: Int
    var Ordem: Int
    var Pagina: Int
    var Descricao: String
    var Tag: String
    var Id_Pai: Int
    var Observacao: String
    var Tamanho_Campo: Int
    var Fl_Obrigatorio: Bool
    var Fl_Somente_Leitura: Bool
    var Controle: String
    var Tipo_Parametro: String
}
