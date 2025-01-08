import UIKit

final class TaxListView: UIView {
    
    // MARK: - UI
    private let containerView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private let viewTitle = ContentViewTitle(title: "Escolha a Taxa:")
    
    private(set) var taxesStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initialize()
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TaxListView {
    func initialize() {
        backgroundColor = Theme.default.greyCard
        
        addSubview(containerView, constraints: true)
        
        containerView.addArrangedSubviews(views: [
            viewTitle, taxesStack
        ])
    }
    
    func installConstraints() {
        containerView.top(to: topAnchor, padding: 16)
        containerView.leadingAndTrailing(to: self, padding: 16)
    }
}
