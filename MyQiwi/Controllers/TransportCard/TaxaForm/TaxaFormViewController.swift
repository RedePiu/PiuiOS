import UIKit

final class TaxaFormViewController: BaseViewController<TaxaFormView> {
    
    // MARK: - Properties
    private let viewModel: TaxaFormViewModel
    
    // MARK: - View Lifecycle
    init(viewModel: TaxaFormViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
