import UIKit

final class ListItemsView: UIView {
    
    // MARK: - UI
    private(set) var loadingView: LoadingView = {
        $0.activityIndicator.startAnimating()
        return $0
    }(LoadingView())
    
    private let mainContainer: UIView = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 7
        return $0
    }(UIView())
    
    private(set) var viewTitle = ContentViewTitle(title: "Solicitação de Cartão")
    
    private(set) var chooseTitle: UILabel = {
        $0.text = "Escolha o formulário"
        $0.font = .boldSystemFont(ofSize: 14)
        return $0
    }(UILabel())
    
    private let scrollView = {
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UIScrollView())
    
    private(set) var stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 30
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
        
        mainContainer.addSubview(chooseTitle, constraints: true)
        mainContainer.addSubview(scrollView, constraints: true)
        
        scrollView.addSubview(stackView, constraints: true)
    }
    
    func installConstraints() {
        viewTitle.top(to: topAnchor, padding: 16)
        viewTitle.leadingAndTrailing(to: self, padding: 16)
        
        mainContainer.top(to: viewTitle.bottomAnchor, padding: 30)
        mainContainer.bottom(to: safeAreaLayoutGuide.bottomAnchor, padding: 16)
        mainContainer.leadingAndTrailing(to: self, padding: 16)
        
        chooseTitle.top(to: mainContainer.topAnchor, padding: 16)
        chooseTitle.leadingAndTrailing(to: mainContainer, padding: 16)
        
        scrollView.top(to: chooseTitle.bottomAnchor, padding: 20)
        scrollView.bottom(to: mainContainer.bottomAnchor, padding: 16)
        scrollView.leadingAndTrailing(to: mainContainer, padding: 16)
        
        stackView.anchors(equalTo: scrollView)
    }
}
