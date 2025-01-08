import UIKit

final class CardUserFormFactory {
    func start(with forms: GetFormsResponse, campos: [CampoFormResponse], baseRN: BaseRN) -> CardUserFormViewController {
        weak var coordinator: TransportCardCoordinator?
        let service = TransportCardService(baseRN: baseRN)
        let viewModel = CardUserFormViewModel(
            service: service,
            idForm: forms.Id_Formulario,
            campos: campos
        )
        let controller = CardUserFormViewController(
            viewModel: viewModel,
            form: forms
        )
        
        viewModel.viewController = controller
        
        return controller
    }
}
