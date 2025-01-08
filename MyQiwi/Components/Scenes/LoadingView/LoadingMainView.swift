import UIKit

final class LoadingView: UIView {
    
    // MARK: - UI
    private let backgroundView: UIView = {
        $0.backgroundColor = .black
        $0.layer.opacity = 0.7
        return $0
    }(UIView())
    
    private let containerStack: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.backgroundColor = Theme.default.greyCard
        $0.layer.cornerRadius = 4
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 5
        $0.layer.cornerRadius = 4
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private(set) var activityIndicator: UIActivityIndicatorView = {
        $0.activityIndicatorViewStyle = .large
        return $0
    }(UIActivityIndicatorView())
    
    private let viewLabel: UILabel = {
        $0.text = "processing".localized
        $0.font = FontCustom.helveticaBold.font(19)
        $0.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
        $0.adjustsFontForContentSizeCategory = true
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
    
    public func showLoader() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.activityIndicator.startAnimating()
            self.backgroundView.isHidden = false
            self.containerStack.isHidden = false
        })
    }
    
    public func hideLoader() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.activityIndicator.stopAnimating()
            self.backgroundView.isHidden = true
            self.containerStack.isHidden = true
            self.removeFromSuperview()
        })
    }
}

private extension LoadingView {
    func initialize() {
        addSubview(backgroundView, constraints: true)
        addSubview(containerStack, constraints: true)
        
        containerStack.addArrangedSubviews(views: [
            activityIndicator, viewLabel
        ])
    }
    
    func installConstraints() {
        backgroundView.anchors(equalTo: self)
        
        containerStack.height(size: 80)
        containerStack.leadingAndTrailing(to: self, padding: 20)
        containerStack.centerY(to: self)

        activityIndicator.top(to: containerStack.topAnchor, padding: 2)
        activityIndicator.leading(to: containerStack.leadingAnchor, padding: 26)
        activityIndicator.centerY(to: containerStack)
        
        viewLabel.top(to: containerStack.topAnchor, padding: 16)
        viewLabel.bottom(to: containerStack.bottomAnchor, padding: 16)
        viewLabel.trailing(to: containerStack.trailingAnchor, padding: 16)
    }
}
