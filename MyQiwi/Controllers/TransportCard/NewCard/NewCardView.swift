import UIKit

final class NewCardView: UIView {
    
    // MARK: - UI
    private let mainContainer: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 30
        return $0
    }(UIStackView())
    
    private let viewTitle = ContentViewTitle(title: "Qual será o seu Cartão?")
    
    private let viewImage: UIImageView = {
        $0.image = UIImage(named: "cartao_form_bem_caieras")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private(set) var buttonsStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
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

private extension NewCardView {
    func initialize() {
        backgroundColor = Theme.default.background
        
        addSubview(mainContainer, constraints: true)
        mainContainer.addArrangedSubviews(views: [
            viewTitle, viewImage, buttonsStack
        ])
    }
    
    func installConstraints() {
        mainContainer.top(to: topAnchor, padding: 16)
        mainContainer.leadingAndTrailing(to: self, padding: 16)
        
        viewTitle.leadingAndTrailing(to: mainContainer)
        
        viewImage.height(size: 200)
        viewImage.leadingAndTrailing(to: mainContainer)
        
        buttonsStack.leadingAndTrailing(to: mainContainer)
    }
}
