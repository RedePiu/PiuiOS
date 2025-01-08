import UIKit

final class SelectableItem: UIView {
    
    public var didTap: (() -> Void)?
    
    // MARK: - UI
    private let mainStack: UIStackView = {
        $0.spacing = 12
        $0.distribution = .fillProportionally
        return $0
    }(UIStackView())
    
    private let textStack: UIStackView = {
        $0.spacing = 12
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private(set) var itemTitle: UILabel = {
        $0.font = FontCustom.helveticaBold.font(14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) var itemDescription: UILabel = {
        $0.font = FontCustom.helveticaRegular.font(14)
        $0.numberOfLines = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) var actionButton = MainButton(
        type: .accept,
        title: "escolher"
    )
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initalize()
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

private extension SelectableItem {
    func initalize() {
        addSubview(mainStack, constraints: true)
        mainStack.addArrangedSubviews(views: [
            textStack, actionButton
        ])
        textStack.addArrangedSubviews(views: [
            itemTitle, itemDescription
        ])
    }
    
    func installConstraints() {
        mainStack.leadingAndTrailing(to: self)
        
        itemTitle.leading(to: textStack.leadingAnchor)
        itemTitle.trailing(to: actionButton.leadingAnchor)
        
        itemDescription.leading(to: textStack.leadingAnchor)
        itemDescription.trailing(to: actionButton.leadingAnchor)
        
        actionButton.centerY(to: mainStack)
        actionButton.width(size: 90)
    }
    
    @objc func actionButtonTap() {
        didTap?()
    }
}
