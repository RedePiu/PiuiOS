import UIKit

final class CardInfoGeneric: UIView {
    
    // MARK: - UI
    private let backgroundCard: UIView = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 4
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 5
        return $0
    }(UIView())
    
    private let mainStack: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    var titleLabel: UILabel = {
        $0.font = FontCustom.helveticaBold.font(14)
        $0.textAlignment = .center
        $0.numberOfLines = .zero
        return $0
    }(UILabel())
    
    var descriptionLabel: UILabel = {
        $0.font = FontCustom.helveticaRegular.font(12)
        $0.textAlignment = .center
        $0.numberOfLines = .zero
        return $0
    }(UILabel())
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.initialize()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CardInfoGeneric {
    func initialize() {
        addSubview(backgroundCard, constraints: true)
        backgroundCard.addSubview(mainStack, constraints: true)
        
        mainStack.addArrangedSubviews(views: [
            titleLabel, imageView, descriptionLabel
        ])
    }
    
    func setupConstraints() {
        backgroundCard.leadingAndTrailing(to: self)
        
        mainStack.leadingAndTrailing(to: backgroundCard, padding: 16)
        mainStack.top(to: backgroundCard.topAnchor, padding: 16)
        mainStack.bottom(to: backgroundCard.bottomAnchor, padding: 16)
        
        imageView.height(size: 80)
        imageView.centerX(to: mainStack)
        
        titleLabel.leadingAndTrailing(to: mainStack)
        descriptionLabel.leadingAndTrailing(to: mainStack)
    }
}
