import UIKit

final class PersonSelectionView: UIView {
    
    // MARK: - UI
    private let viewTitle = ContentViewTitle(title: "Quem é o solicitante?")
    
    private let imageContent: UIImageView = {
        $0.image = UIImage(named: "img_student1")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let buttonsStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 16
        return $0
    }(UIStackView())
    
    private(set) var selfButton = MainButton(
        type: .primary,
        title: "Eu"
    )
    
    private(set) var otherPersonButton = MainButton(
        type: .primary,
        title: "outra pessoa"
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

private extension PersonSelectionView {
    func initialize() {
        backgroundColor = Theme.default.greyCard
        
        addSubview(viewTitle, constraints: true)
        addSubview(imageContent, constraints: true)
        addSubview(buttonsStack, constraints: true)
        buttonsStack.addArrangedSubviews(views: [
            selfButton, otherPersonButton
        ])
    }
    
    func installConstraints() {
        viewTitle.top(to: topAnchor, padding: 16)
        viewTitle.leadingAndTrailing(to: self, padding: 16)
        
        imageContent.top(to: viewTitle.bottomAnchor, padding: 30)
        imageContent.height(size: 200)
        imageContent.centerX(to: self)
        
        buttonsStack.top(to: imageContent.bottomAnchor, padding: 30)
        buttonsStack.leadingAndTrailing(to: self, padding: 16)
    }
}
