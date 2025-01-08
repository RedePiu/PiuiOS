import UIKit

final class NoticeView: UIView {
    
    // MARK: - Properties
    public var buttonTitle = String()
    
    // MARK: - UI
    private let mainStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private(set) var contentImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private(set) var titleLabel: UILabel = {
        $0.text = "É isso ai! Agora é só aguardar!"
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) var descriptionLabel: UILabel = {
        $0.text = "Agora é só aguardar a aprovação da empresa! A gente te avisa quando tudo estiver certo :)"
        $0.textAlignment = .center
        $0.numberOfLines = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) lazy var actionButton = MainButton(
        type: .accept,
        title: buttonTitle
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

private extension NoticeView {
    func initialize() {
        backgroundColor = Theme.default.greyCard
        
        addSubview(mainStack)
        mainStack.addArrangedSubviews(views: [
            contentImageView, titleLabel, descriptionLabel, actionButton
        ])
    }
    
    func installConstraints() {
        mainStack.leadingAndTrailing(to: self, padding: 16)
        mainStack.top(to: topAnchor, padding: 30)
        
        contentImageView.height(size: 200)
        contentImageView.centerX(to: mainStack)
    }
}
