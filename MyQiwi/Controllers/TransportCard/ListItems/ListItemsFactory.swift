import UIKit

final class ListItemsFactory {
    func start(with baseRN: TaxaCardRN) -> ListItemsViewController {
        let service = TransportCardService(baseRN: baseRN)
        let viewModel = ListItemsViewModel(service: service)
        let controller = ListItemsViewController(
            viewModel: viewModel,
            forms: baseRN.getAllGetForms(),
            baseRN: baseRN
        )
        
        return controller
    }
}
