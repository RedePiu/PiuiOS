import UIKit

final class TaxListViewModel {
    
    // MARK: - Properties
    private let service: TransportCardService
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    private let cpf: String
    
    private(set) var getForms = [GetFormsResponse]()
    private(set) var getTaxas = [GetTaxasResponse]()
    
    private(set) var idFormSaved = Int()
    private(set) var viaForm = Int()
    private(set) var idCarga = Int()
    
    // MARK: - Constructor
    init(service: TransportCardService, cpf: String) {
        self.service = service
        self.cpf = cpf
    }
    
    // MARK: - Functions
    
    func getAllForms(completion: @escaping (([GetFormsResponse]) -> Void)) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            service.getAllForms(
                idEmissor: produtoProdata.id_emissor,
                cpf: Constants.cpfTaxa,
                completion: { response in
                    
                    switch response {
                    case .success(let data):
                        self.getForms.append(data)
                        completion(self.getForms)
                        
                    case .error(let error):
                        print("@! >>> ERRO_FORMS: ", error)
                    }
                }
            )
        }
    }
    
    func getAllTaxes(completion: @escaping (([GetTaxasResponse]) -> Void)) {
        service.getAllTaxas(idEmissor: produtoProdata.id_emissor) { [weak self] response in
            guard let self else { return }
            
            switch response {
            case .success(let data):
                self.getTaxas.append(data)
                completion(self.getTaxas)
                
            case .error(let error):
                print("@! >>> ERRO_TAXAS: ", error)
            }
        }
    }
    
    func orderPayments(_ response: GetTaxasResponse, idCarga: Int, idForm: Int, completion: @escaping (() -> Void)) {
        QiwiOrder.checkoutBody.requestProdata = nil
        
        QiwiOrder.checkoutBody.requestTaxaCampo = RequestTaxaAdm()
        QiwiOrder.checkoutBody.requestTaxaCampo?.id_taxa = response.Id_Taxa
        QiwiOrder.checkoutBody.requestTaxaCampo?.cpf = Constants.cpfTaxa
        QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos = []
        
        for campo in response.Campos ?? [] {
            if campo.Tag == "id_formulario" {
                let objeto = CamposRequestTaxaAdm()
                objeto.id_campo = campo.Id_Campo
                objeto.valor_campo = "\(idForm)"
                QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos?.append(objeto)
            }
            if campo.Tag == "tipo_formulario" {
                let objeto = CamposRequestTaxaAdm()
                objeto.id_campo = campo.Id_Campo
                objeto.valor_campo = "\(idCarga)"
                QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos?.append(objeto)
            }
        }
        
        QiwiOrder.setTransitionAndValue(value: response.Valor_Taxa)
        QiwiOrder.productName = response.Nome
        QiwiOrder.setPrvId(prvId: response.Id_Prv)
        QiwiOrder.instructionsViewIsHidden = true
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        completion()
    }
}
