import UIKit

final class CardUserFormView: UIView {
    
    // MARK: - Properties
    public var backTap: (() -> Void)?
    public var continueTap: (() -> Void)?
    
    // MARK: - UI
    private let container = UIView()
    
    private lazy var scrollView: UIScrollView = {
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        return $0
    }(UIScrollView())
    
    private(set) var mainStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 20
        return $0
    }(UIStackView())
    
    private(set) var viewLabel = UILabel()
    
    private(set) var viewImage: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private(set) var materialStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private(set) var uploadFilesStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private let buttonsStack: UIStackView = {
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private(set) lazy var backButton = ActionViewButton(
        type: .attention,
        title: "Voltar",
        setButtonAction: backTap ?? {}
    )
    private(set) lazy var continueButton = ActionViewButton(
        type: .primary,
        title: "Continuar",
        setButtonAction: continueTap ?? {}
    )
    
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

private extension CardUserFormView {
    func initialize() {
        backgroundColor = Theme.default.greyCard
        
        addSubview(container, constraints: true)
        addSubview(buttonsStack, constraints: true)
        
        container.addSubview(scrollView, constraints: true)
        scrollView.addSubview(mainStack, constraints: true)
        
        mainStack.addArrangedSubviews(views: [
            viewLabel, viewImage, materialStack, uploadFilesStack
        ])
        buttonsStack.addArrangedSubviews(views: [
            backButton, continueButton
        ])
    }
    
    func installConstraints() {
        container.top(to: topAnchor)
        container.leadingAndTrailing(to: self)
        container.bottom(to: buttonsStack.topAnchor)
        
        scrollView.leadingAndTrailing(to: container)
        scrollView.top(to: container.topAnchor)
        scrollView.bottom(to: container.bottomAnchor)
        
        mainStack.top(to: scrollView.topAnchor, padding: 16)
        mainStack.bottom(to: scrollView.bottomAnchor, padding: 16)
        mainStack.leading(to: scrollView.leadingAnchor)
        mainStack.trailing(to: scrollView.trailingAnchor)
        
        viewImage.height(size: 200)
        viewImage.leadingAndTrailing(to: mainStack)
            
        buttonsStack.height(size: 50)
        buttonsStack.bottom(to: safeAreaLayoutGuide.bottomAnchor)
        buttonsStack.leadingAndTrailing(to: self)
    }
}
