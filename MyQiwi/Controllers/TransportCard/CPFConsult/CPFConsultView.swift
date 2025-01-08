import UIKit

final class CPFConsultView: UIView {
    
    // MARK: - Properties
    public var backTap: (() -> Void)?
    public var continueTap: (() -> Void)?
    
    // MARK: - UI
    let mainStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 30
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private let buttonsStack: UIStackView = {
        $0.distribution = .fillEqually
        return $0
    }(UIStackView())
    
    private(set) var viewTitle = ContentViewTitle(title: "Qual CPF do solicitante?")
    
    private(set) var cpfInputView: MaterialField = {
        $0.placeholder = "transport_students_form_user_cpf".localized
        $0.formatPattern = Constants.FormatPattern.Default.CPF.rawValue
        $0.borderStyle = .roundedRect
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(MaterialField(frame: .zero))
    
    private(set) lazy var backButton = ActionViewButton(
        type: .attention,
        title: "Voltar",
        setButtonAction: backTap
    )
    private(set) lazy var continueButton = ActionViewButton(
        type: .primary,
        title: "Continuar",
        setButtonAction: continueTap
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

private extension CPFConsultView {
    func initialize() {
        backgroundColor = Theme.default.greyCard
        
        addSubview(mainStack, constraints: true)
        addSubview(buttonsStack, constraints: true)
        mainStack.addArrangedSubviews(views: [
            viewTitle, cpfInputView
        ])
        buttonsStack.addArrangedSubviews(views: [
            backButton, continueButton
        ])
    }
    
    func installConstraints() {
        mainStack.top(to: topAnchor, padding: 16)
        mainStack.leadingAndTrailing(to: self, padding: 16)
        
        buttonsStack.height(size: 50)
        buttonsStack.leadingAndTrailing(to: self)
        buttonsStack.bottom(to: safeAreaLayoutGuide.bottomAnchor)
    }
}
