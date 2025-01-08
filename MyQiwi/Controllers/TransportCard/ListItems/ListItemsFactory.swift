import UIKit

final class ListItemsFactory {
    func start(with baseRN: BaseRN) -> ListItemsViewController {
        weak var coordinator: TransportCardCoordinator?
        let service = TransportCardService(baseRN: baseRN)
        let viewModel = ListItemsViewModel(service: service)
        let controller = ListItemsViewController(viewModel: viewModel)
        
        coordinator?.baseRN = baseRN
        controller.baseRN = baseRN
        
        return controller
    }
}
