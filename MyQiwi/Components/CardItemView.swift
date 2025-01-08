import UIKit

final class CardItemView: UIView {
    
    // MARK: - UI
    private let container: UIView = {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 7
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private(set) var addSubivews: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        initialize()
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CardItemView {
    func initialize() {
        addSubview(container)
        container.addSubview(addSubivews)
    }
    
    func installConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            addSubivews.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            addSubivews.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            addSubivews.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            addSubivews.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
    }
}
