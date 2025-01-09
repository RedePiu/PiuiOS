import UIKit

final class TitledDescriptionRow: UIView {
    
    // MARK: - Properties
    public var itemTitle = String()
    public var itemDescription = String()
    public var didTap: (() -> Void)?
    
    private var setItemTitle: String {
        get { return itemTitle }
        set { itemTitle = newValue }
    }
    
    private var setDescriptionTitle: String {
        get { return itemDescription }
        set { itemDescription = newValue }
    }
    
    // MARK: - UI
    private(set) lazy var mainButton: UIButton = {
        $0.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let backgroundView: UIView = {
        $0.backgroundColor = .white
//        $0.layer.shadowColor = UIColor.black.cgColor
//        $0.layer.shadowOpacity = 0.2
//        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
//        $0.layer.shadowRadius = 5
//        $0.layer.cornerRadius = 8
        return $0
    }(UIView())
    
    private let containerView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 4
        return $0
    }(UIStackView())
    
    private(set) var titleLabelView: UILabel = {
        $0.font = FontCustom.helveticaBold.font(14)
        return $0
    }(UILabel())
    
    private(set) var descriptionLabel: UILabel = {
        $0.font = FontCustom.helveticaRegular.font(14)
        return $0
    }(UILabel())
    
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

// MARK: - Private functions
private extension TitledDescriptionRow {
    func initialize() {
        addSubview(backgroundView, constraints: true)
        addSubview(mainButton, constraints: true)
        
        backgroundView.addSubview(containerView, constraints: true)
        
        containerView.addArrangedSubviews(views: [
            titleLabelView, descriptionLabel
        ])
        
        bringSubview(toFront: mainButton)
    }
    
    func installConstraints() {
        mainButton.anchors(equalTo: self)
        backgroundView.anchors(equalTo: self)
        
        containerView.top(to: backgroundView.topAnchor, padding: 8)
        containerView.bottom(to: backgroundView.bottomAnchor, padding: 8)
        containerView.leadingAndTrailing(to: backgroundView, padding: 8)
    }
    
    @objc func didTapAction() {
        self.didTap?()
    }
}
