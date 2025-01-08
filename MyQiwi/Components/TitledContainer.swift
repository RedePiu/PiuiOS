import UIKit

final class TitledContainer: UIView {
    
    // MARK: - Properties
    public var viewTitle = String()
    public var imageName = String()
    
    private var setupTitle: String {
        get { return viewTitle }
        set { viewTitle = newValue }
    }
    
    private var setupImage: String {
        get { return imageName }
        set { imageName = newValue }
    }
    
    // MARK: - UI
    private let mainStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 30
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private lazy var titleLabel: UILabel = {
        $0.text = setupTitle
        $0.font = .systemFont(ofSize: 17)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var imageContent: UIImageView = {
        $0.image = UIImage(named: setupImage)
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private(set) var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initialize()
        installConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TitledContainer {
    func initialize() {
        addSubview(mainStack)
        mainStack.addSubview(titleLabel)
        mainStack.addSubview(imageContent)
        mainStack.addSubview(contentView)
    }
    
    func installConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStack.topAnchor.constraint(equalTo: topAnchor),

            imageContent.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor),
            imageContent.heightAnchor.constraint(equalToConstant: 200),
            
            contentView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
    }
}
