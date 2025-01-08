import UIKit

final class MainButton: UIButton {
    
    // MARK: - Properties
    public var didTap: (() -> Void)?
    
    // MARK: - Init
    init(type: ActionButtonType, title: String) {
        super.init(frame: .zero)
        setupLayoutButton(as: type, with: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup UI
    private func setupLayoutButton(as type: ActionButtonType, with title: String) {
        setTitle(title, uppercase: false)
        titleLabel?.font = FontCustom.helveticaBold.font(14)
        addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        
        layer.cornerRadius = 8
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        
        switch type {
        case .attention:
            backgroundColor = Theme.default.orange
            layer.shadowColor = Theme.default.orange.cgColor
        case .danger:
            backgroundColor = Theme.default.red
            layer.shadowColor = Theme.default.red.cgColor
        case .accept:
            backgroundColor = Theme.default.green
            layer.shadowColor = Theme.default.green.cgColor
        case .primary:
            backgroundColor = Theme.default.primary
            layer.shadowColor = Theme.default.primaryDark.cgColor
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc
    func buttonDidTap() {
        didTap?()
    }
}
