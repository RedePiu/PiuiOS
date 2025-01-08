import UIKit

final class ContentViewTitle: UILabel {

    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        
        text = title
        font = FontCustom.helveticaBold.font(17)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
