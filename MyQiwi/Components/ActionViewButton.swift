import UIKit

enum ActionButtonType {
    case attention
    case danger
    case accept
    case primary
}

final class ActionViewButton: UIButton {
    
    private var title = String()
    var setButtonAction: (() -> Void)?
    
    private var buttonTitle: String {
        get { return title }
        set { title = newValue }
    }
    
    init(type: ActionButtonType, title: String, setButtonAction: (() -> Void)?) {
        self.title = title
        self.setButtonAction = setButtonAction
        super.init(frame: .zero)
        setupButton(with: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private functions
private extension ActionViewButton {
    func setupButton(with type: ActionButtonType) {
        setTitle(buttonTitle, uppercase: true)
        
        switch type {
        case .attention:
            setBackgroundColor(color: Theme.default.orange)
        case .danger:
            setBackgroundColor(color: Theme.default.red)
        case .accept:
            setBackgroundColor(color: Theme.default.green)
        case .primary:
            setBackgroundColor(color: Theme.default.blue)
        }
        
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    func installConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    func buttonAction() {
        setButtonAction?()
    }
}
