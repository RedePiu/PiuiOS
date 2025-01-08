import UIKit

final class CPFConsultViewModel {
    
    // MARK: - Properties
    weak var viewController: CPFConsultViewController?
    private let service: TransportCardService
    private var produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    
    var forms = [GetFormsResponse]()
    
    init(service: TransportCardService) {
        self.service = service
    }
    
    func getCards(cpf: String, completion: @escaping ((TaxaCardResponse) -> Void)) {
        service.getAllCards(idEmissor: produtoProdata.id_emissor, cpf: cpf) { response in
            switch response {
            case .success(let model):
                completion(model)
            case .error(let error):
                print("@! >>> CARD_ERROR: ", error)
                self.viewController?.showErrorThatDismissPage()
            }
        }
    }
    
    func getForms(userCPF: String, completion: @escaping (([GetFormsResponse]) -> Void)) {
        service.getAllForms(idEmissor: produtoProdata.id_emissor, cpf: userCPF) { response in
            switch response {
            case .success(let data):
                self.forms.append(data)
                completion(self.forms)
            case .error(let error):
                print("@! >>> FORM_ERROR: ", error)
                self.viewController?.showErrorThatDismissPage()
            }
        }
    }
    
    func getCpfData(valid: Bool, for cpf: String = "", completion: (() -> Void)? = nil) {
        if valid && !Util.validadeCPF(cpf) {
            viewController?.displayAlert(
                title: "Dados Obrigatórios",
                description: "forgot_qiwi_cpf_invalid".localized
            )
        }
        
        completion?()
    }
}
