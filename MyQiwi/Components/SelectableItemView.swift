import UIKit

final class SelectableItem: UITableViewCell {
    
    public var didTap: (() -> Void)?
    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        $0.addTarget(self, action: #selector(actionButtonTap))
        return $0
    }(UITapGestureRecognizer())
    
    // MARK: - UI
    private(set) var mainContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIView())
    
    private let textStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private(set) var itemTitle: UILabel = {
        $0.font = FontCustom.helveticaBold.font(12)
        $0.textColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) var itemDescription: UILabel = {
        $0.font = FontCustom.helveticaBold.font(16)
        $0.numberOfLines = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) var itemComment: UILabel = {
        $0.font = FontCustom.helveticaRegular.font(12)
        $0.numberOfLines = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) var actionButton = MainButton(
        type: .accept,
        title: "escolher"
    )
    
    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        initalize()
        installConstraints()
        
        mainContainer.addGestureRecognizer(gestureRecognizer)
        mainContainer.isUserInteractionEnabled = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        initalize()
//        installConstraints()
//        
//        mainContainer.addGestureRecognizer(gestureRecognizer)
//        mainContainer.isUserInteractionEnabled = true
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

private extension SelectableItem {
    func initalize() {
        addSubview(mainContainer, constraints: true)
        mainContainer.addSubview(textStack, constraints: true)
        
        textStack.addArrangedSubviews(views: [
            itemTitle, itemDescription, itemComment
        ])
        
        mainBoxShadow(to: mainContainer)
    }
    
    func installConstraints() {
        height(size: mainContainer.frame.height)
        mainContainer.leadingAndTrailing(to: self, padding: 8)
        
        textStack.top(to: mainContainer.topAnchor, padding: 12)
        textStack.bottom(to: mainContainer.bottomAnchor, padding: 12)
        textStack.leadingAndTrailing(to: mainContainer, padding: 12)
    }
    
    @objc func actionButtonTap() {
        didTap?()
    }
}
