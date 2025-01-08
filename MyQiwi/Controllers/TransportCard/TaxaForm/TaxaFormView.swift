import UIKit

final class TaxaFormView: UIView {
    
    // MARK: - UI
    private let mainContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private(set) var viewTitle: UILabel = {
        $0.text = "Escolha a taxa:"
        $0.font = .systemFont(ofSize: 17)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) var chooseTitle: UILabel = {
        $0.text = "Escolha o formulário"
        $0.font = .boldSystemFont(ofSize: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private(set) var stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 30
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStackView())
    
    
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

private extension TaxaFormView {
    func initialize() {
        backgroundColor = Theme.default.background
        
        addSubview(viewTitle)
        addSubview(mainContainer)
        mainContainer.addSubview(chooseTitle)
        mainContainer.addSubview(stackView)
    }
    
    func installConstraints() {
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            viewTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            viewTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            mainContainer.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 30),
            mainContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            chooseTitle.topAnchor.constraint(equalTo: mainContainer.topAnchor, constant: 16),
            chooseTitle.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 16),
            chooseTitle.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: chooseTitle.bottomAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor, constant: -16)
        ])
    }
}
