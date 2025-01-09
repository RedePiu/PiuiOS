import UIKit

final class ListItemsView: UIView {
    
    // MARK: - UI
    private let mainContainer = UIView()
    private(set) var viewTitle = ContentViewTitle(title: "Escolha o formulário")
    
    private(set) var activityIndicator = {
        $0.hidesWhenStopped = true
        $0.startAnimating()
        return $0
    }(UIActivityIndicatorView())
    
    private let scrollView = {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())
    
    private(set) var stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    private(set) var cellView = SelectableItem()
    
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

private extension ListItemsView {
    func initialize() {
        backgroundColor = Theme.default.background
        
        addSubview(viewTitle, constraints: true)
        addSubview(mainContainer, constraints: true)
        
        mainContainer.addSubview(scrollView, constraints: true)
        mainContainer.addSubview(activityIndicator, constraints: true)
        
        scrollView.addSubview(stackView, constraints: true)
    }
    
    func installConstraints() {
        viewTitle.top(to: topAnchor, padding: 24)
        viewTitle.leadingAndTrailing(to: self, padding: 24)
        
        activityIndicator.center(to: mainContainer)
        
        mainContainer.top(to: viewTitle.bottomAnchor, padding: 16)
        mainContainer.bottom(to: safeAreaLayoutGuide.bottomAnchor, padding: 16)
        mainContainer.leadingAndTrailing(to: self, padding: 16)
        
        scrollView.top(to: mainContainer.topAnchor, padding: 16)
        scrollView.bottom(to: mainContainer.bottomAnchor, padding: 16)
        scrollView.leadingAndTrailing(to: mainContainer)
    
        stackView.leadingAndTrailing(to: self)
    }
}
