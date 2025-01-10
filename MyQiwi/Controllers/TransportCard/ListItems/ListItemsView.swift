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
    
    private(set) var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
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
        
        mainContainer.addSubview(activityIndicator, constraints: true)
        mainContainer.addSubview(tableView, constraints: true)
    }
    
    func installConstraints() {
        viewTitle.top(to: topAnchor, padding: 24)
        viewTitle.leadingAndTrailing(to: self, padding: 24)
        
        activityIndicator.center(to: mainContainer)
        
        mainContainer.top(to: viewTitle.bottomAnchor, padding: 16)
        mainContainer.bottom(to: safeAreaLayoutGuide.bottomAnchor, padding: 16)
        mainContainer.leadingAndTrailing(to: self, padding: 16)
        
        tableView.top(to: mainContainer.topAnchor)
        tableView.bottom(to: mainContainer.bottomAnchor)
        tableView.leadingAndTrailing(to: mainContainer)
    }
}
