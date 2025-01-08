import UIKit

final class PersonSelectionFactory {
    func start(with baseRN: BaseRN) -> PersonSelectionViewController {
        let service = TransportCardService(baseRN: baseRN)
        let viewModel = PersonSelectionViewModel(service: service)
        let controller = PersonSelectionViewController(viewModel: viewModel)
        return controller
    }
}
