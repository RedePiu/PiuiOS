import UIKit

extension String {
    var words: Set<String> {
        return Set(components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty })
    }
    
    func containsWords(of string: String) -> Bool {
        return words.isSuperset(of: string.words)
    }
    
//    func toCurrency() -> String {
//        let format = NumberFormatter()
//        format.numberStyle = .currency
//        format.currencySymbol = "R$"
//        format.string(from: NSNumber(value: Int(item.Valor_Taxa)) ) ?? "R$0,00"
//    }
}
