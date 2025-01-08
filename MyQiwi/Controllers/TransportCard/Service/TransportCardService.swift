import ObjectMapper
import UIKit

protocol TransportCardServiceDelegate: AnyObject {
    func getAllForms(idEmissor: Int, cpf: String, completion: @escaping ((MainResponse<GetFormsResponse>) -> Void))
    func getAllTaxas(idEmissor: Int, completion: @escaping ((MainResponse<GetTaxasResponse>) -> Void))
    func getAllCardTypes(idEmissor: Int, completion: @escaping ((MainResponse<MenuCardTypeResponse>) -> Void))
    func getAllCards(idEmissor: Int, cpf: String, completion: @escaping ((MainResponse<TaxaCardResponse>) -> Void))
}

class TransportCardService: TransportCardServiceDelegate {
    
    // MARK: - Properties
    private let baseRN: BaseRN
    private let parser = DataParser()
    
    private var formsResponse = [GetFormsResponse]()
    private var cardType = [MenuCardTypeResponse]()
    private var taxaCard = [TaxaCardResponse]()
    private var taxas = [GetTaxasResponse]()
    
    private var itemResponse = [AnyObject]()
    
    init(baseRN: BaseRN) {
        self.baseRN = baseRN
    }
    
    // MARK: - Delegate Functions
    func getAllForms(idEmissor: Int, cpf: String, completion: @escaping ((MainResponse<GetFormsResponse>) -> Void)) {
        let model = GetFormsModel(
            cpf: cpf,
            id_emissor: idEmissor
        )
        let serviceBody = baseRN.updateJsonWithHeader(
            jsonBody: model.generateJsonBodyAsString()
        )
        let request = RestApi().generedRequestPost(
            url: BaseURL.AuthenticatedTaxaGetForms,
            json: serviceBody
        )
        
        baseRN.callApiForList(GetFormsResponse.self, request: request) { response in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                if response.sucess {
                    if let data = response.body?.data {
                        self.formsResponse = data
                        self.formsResponse.forEach({
                            completion(.success(model: $0))
                        })
                    }
                } else {
                    if let error = response.body?.messages {
                        error.forEach({
                            completion(.error(error: $0))
                        })
                    }
                }
            }
        }
    }
    
    func getAllTaxas(idEmissor: Int, completion: @escaping ((MainResponse<GetTaxasResponse>) -> Void)) {
        let model = GetEmissorModel(
            idEmissor: idEmissor
        )
        let serviceBody = baseRN.updateJsonWithHeader(
            jsonBody: model.toJSONString() ?? ""
        )
        let request = RestApi().generedRequestPost(
            url: BaseURL.AuthenticatedTaxaGet,
            json: serviceBody
        )
        
        apiResponse(with: request) { [weak self] (response: GetTaxasResponse) in
            guard let self else { return }
            
            self.taxas.append(response)
            self.taxas.forEach({
                completion(.success(model: $0))
            })
        }
    }
    
    func getAllCardTypes(idEmissor: Int, completion: @escaping ((MainResponse<MenuCardTypeResponse>) -> Void)) {
        let model = GetEmissorModel(
            idEmissor: idEmissor
        )
        let serviceBody = baseRN.updateJsonWithHeader(
            jsonBody: model.toJSONString() ?? ""
        )
        let request = RestApi().generedRequestPost(
            url: BaseURL.AuthenticatedTaxaGetCardTypes,
            json: serviceBody
        )
        
        apiResponse(with: request) { [weak self] (response: MenuCardTypeResponse) in
            guard let self else { return }
            
            self.cardType.append(response)
            completion(.success(model: response))
        }
    }
    
    func getAllCards(idEmissor: Int, cpf: String, completion: @escaping ((MainResponse<TaxaCardResponse>) -> Void)) {
        let model = CardConsultModel(
            idEmissor: idEmissor,
            cpf: cpf.removeAllOtherCaracters()
        )
        let serviceBody = baseRN.updateJsonWithHeader(
            jsonBody: model.toJSONString() ?? ""
        )
        let request = RestApi().generedRequestPost(
            url: BaseURL.AuthenticatedTaxaGetCards,
            json: serviceBody
        )
        
        apiResponse(with: request) { [weak self] (response: TaxaCardResponse) in
            guard let self else { return }
            
            self.taxaCard.append(response)
            self.taxaCard.forEach({
                completion(.success(model: $0))
            })
        }
    }
}

private extension TransportCardService {
    func apiResponse<T: BasePojo>(with request: URLRequest, completion: @escaping ((T) -> Void)) {
        baseRN.callApiForList(T.self, request: request) { response in
            if response.sucess {
                if let data = response.body?.data {
                    data.forEach({
                        completion($0)
                    })
                }
            }
            
            if let error = response.body?.messages {
                error.forEach({
                    print("@! >>> MENSAGEM: ", $0)
                })
            }
        }
    }
}
