import UIKit

final class TaxListView: UIView {
    
    // MARK: - Properties
    public var backTap: (() -> Void)?
    public var continueTap: (() -> Void)?
    
    // MARK: - UI
    private var mainContainer: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.sizeToFit()
        return $0
    }(UIStackView())
    
    private let viewTitle = ContentViewTitle(title: "Escolha a taxa:")
    
    private(set) var taxesStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fillEqually
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
        
        addSubview(mainContainer, constraints: true)
        mainContainer.addArrangedSubviews(views: [
            viewTitle, taxesStack
        ])
    }
    
    func installConstraints() {
        mainContainer.top(to: topAnchor, padding: 16)
        mainContainer.leadingAndTrailing(to: self, padding: 16)
        
        viewTitle.leadingAndTrailing(to: mainContainer)
        taxesStack.leadingAndTrailing(to: mainContainer)
    }
}
