import UIKit

final class ListItemsViewModel {
    
    // MARK: - Properties
    weak var controller: ListItemsViewController?
    private let service: TransportCardService
    
    var forms = [GetFormsResponse]()
    var typeCard = [MenuCardTypeResponse]()
    var campoForm = [CampoFormResponse]()
    
    // MARK: - Init
    init(service: TransportCardService) {
        self.service = service
    }

    // MARK: - Functions
    func getAllForms(idEmissor: Int, cpf: String, completion: @escaping (([GetFormsResponse], [CampoFormResponse]) -> Void)) {
        service.getAllForms(idEmissor: idEmissor, cpf: cpf) { [weak self] response in
            guard let self else { return }
            
            switch response {
            case .success(let model):
                self.forms.append(model)
                
                for item in self.forms {
                    self.campoForm = item.Campos
                }
                
                completion(self.forms, self.campoForm)
            default:
                break
            }
        }
    }
    
    func getAllCardType(
        idEmissor: Int,
        completion: @escaping (([MenuCardTypeResponse]) -> Void)
    ) {
        service.getAllCardTypes(idEmissor: idEmissor) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let model):
                self.typeCard.append(model)
                completion(self.typeCard)
            case .error(let error):
                print("@! >>> ERROR: ", error)
            }
        }
    }
}
