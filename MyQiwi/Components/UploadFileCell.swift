import UIKit

final class UploadFileCell: UIView {
    
    // MARK: - Properties
    public var itemTitle = String()
    public var itemDescription = String()
    public var imageTag = Int()
    public var buttonTag = Int()
    public var didTapUpload: (() -> Void)?
    
    private var setItemTitle: String {
        get { return itemTitle }
        set { itemTitle = newValue }
    }
    
    private var setItemDescription: String {
        get { return itemDescription }
        set { itemDescription = newValue }
    }
    
    private var setImageTag: Int {
        get { return imageTag }
        set { imageTag = newValue }
    }
    
    private var setButtonTag: Int {
        get { return buttonTag }
        set { buttonTag = newValue }
    }
    
    // MARK: - UI
    private let mainStack: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        return $0
    }(UIStackView())
    
    private(set) lazy var titleLabel: UILabel = {
        $0.text = setItemTitle
        $0.font = FontCustom.helveticaBold.font(16)
        return $0
    }(UILabel())
    
    private(set) lazy var observationLabel: UILabel = {
        $0.text = setItemDescription
        $0.font = FontCustom.helveticaRegular.font(14)
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private(set) lazy var previewImage: UIImageView = {
        $0.tag = setImageTag
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        return $0
    }(UIImageView())
    
    private let buttonStack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    private let fileIcon: UIImageView = {
        $0.image = UIImage(named: "ic_file")
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private(set) lazy var uploadButton: UIButton = {
        $0.tag = setButtonTag
        $0.setTitle("+ Adicionar Arquivo", for: .normal)
        $0.addTarget(self, action: #selector(didTapSelectFile), for: .touchUpInside)
        $0.contentHorizontalAlignment = .left
        return $0
    }(UIButton(type: .system))
    
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

private extension UploadFileCell {
    func initialize() {
        addSubview(mainStack, constraints: true)
        
        buttonStack.addArrangedSubviews(views: [
            fileIcon, uploadButton
        ])
        
        mainStack.addArrangedSubviews(views: [
            titleLabel, observationLabel, previewImage, buttonStack
        ])
    }
    
    func installConstraints() {
        mainStack.anchors(equalTo: self)
        fileIcon.width(size: 30)
        
        previewImage.height(size: 50)
        
        titleLabel.height(size: 20)
        titleLabel.leadingAndTrailing(to: mainStack)
        
        observationLabel.height(size: 16)
        observationLabel.leadingAndTrailing(to: mainStack)
        
        buttonStack.height(size: 30)
        buttonStack.leadingAndTrailing(to: mainStack)
    }
    
    @objc func didTapSelectFile() {
        self.didTapUpload?()
    }
}
