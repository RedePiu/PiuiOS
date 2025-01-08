import UIKit

final class CPFConsultFactory {
    func start(with baseRN: BaseRN) -> CPFConsultViewController {
        let service = TransportCardService(baseRN: baseRN)
        let viewModel = CPFConsultViewModel(service: service)
        let controller = CPFConsultViewController(viewModel: viewModel, baseRN: baseRN)
        
        viewModel.viewController = controller
        
        return controller
    }
}
