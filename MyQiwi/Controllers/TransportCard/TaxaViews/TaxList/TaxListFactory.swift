import UIKit

final class TaxListFactory {
    func start(with baseRN: BaseRN, cpf: String) -> TaxListViewController {
        let service = TransportCardService(baseRN: baseRN)
        let viewModel = TaxListViewModel(
            service: service,
            cpf: cpf
        )
        let controller = TaxListViewController(viewModel: viewModel)
        
        return controller
    }
}
