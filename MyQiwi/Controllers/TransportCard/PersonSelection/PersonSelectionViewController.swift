import UIKit

final class PersonSelectionViewController: BaseViewController<PersonSelectionView> {
    
    // MARK: - Properties
    private let viewModel: PersonSelectionViewModel
    private lazy var taxaCardRN = TaxaCardRN(delegate: self)
    
    // MARK: - View Lifecycle
    init(viewModel: PersonSelectionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonAction()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigationBar(with: QiwiOrder.selectedMenu.desc)
    }
}

extension PersonSelectionViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {}
}

// MARK: - Private functions
private extension PersonSelectionViewController {
    func setupButtonAction() {
        baseView.selfButton.didTap = { [weak self] in
            guard let self else { return }
            Constants.cpfTaxa = "eu"
            self.showLoading(self)
            self.pushViewController(CPFConsultFactory().start(with: self.taxaCardRN))
        }
        
        baseView.otherPersonButton.didTap = { [weak self] in
            guard let self else { return }
            self.pushViewController(CPFConsultFactory().start(with: taxaCardRN))
        }
    }
    
}
