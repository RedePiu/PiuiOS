import UIKit

protocol EnumDescription {
    var description: String { get }
}

//enum TipoCarga: Int, EnumDescription {
//    case estudante = 1
//    case comum = 4
//    
//    var description: String {
//        switch self {
//        case .estudante:
//            return "Estudante"
//        case .comum:
//            return "Comum"
//        }
//    }
//}
    
enum ItemType: String, CaseIterable {
    case north, south, east, west
    
    static var asArray: [ItemType] { self.allCases }
    
    func asInt() -> Int {
        return ItemType.asArray.firstIndex(where: { $0 == self }) ?? 0
    }
}
