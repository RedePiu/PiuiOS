import UIKit

final class TaxListViewModel {
    
    // MARK: - Properties
    private var idFormSaved = Int()
    
//    func carregaTipoCarga() {
//        Util.showLoading(self)
//        taxaCardRN.getMenuCardTypeResponses(idEmissor: produtoProdata.id_emissor)
//    }
    
    func createItemCell(with taxas: [GetTaxasResponse], stack: UIStackView) {
        let filterTaxes = taxas.filter({
            $0.Tipo_Formulario == Constants.idTipoCarga && $0.Via == Constants.viaCarga
        })
        
        for item in filterTaxes {
            let cell = TitledDescriptionRow()
            cell.tag = item.Id_Taxa
            cell.itemTitle = item.Nome
            cell.itemDescription = String(item.Valor_Taxa)
            stack.addArrangedSubviews(views: [cell])
        }
    }
    
    func orderPayments(_ response: GetTaxasResponse, completion: @escaping (() -> Void)) {
        QiwiOrder.checkoutBody.requestProdata = nil
        
        QiwiOrder.checkoutBody.requestTaxaCampo = RequestTaxaAdm()
        QiwiOrder.checkoutBody.requestTaxaCampo?.id_taxa = response.Id_Taxa
        QiwiOrder.checkoutBody.requestTaxaCampo?.cpf = Constants.cpfTaxa
        QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos = []
        
        for campo in response.Campos ?? [] {
            if campo.Tag == "id_formulario" {
                let objeto = CamposRequestTaxaAdm()
                objeto.id_campo = campo.Id_Campo
                objeto.valor_campo = "\(self.idFormSaved)"
                QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos?.append(objeto)
            } else if campo.Tag == "tipo_formulario"{
                let objeto = CamposRequestTaxaAdm()
                objeto.id_campo = campo.Id_Campo
                objeto.valor_campo = "\(Constants.idTipoCarga)"
                QiwiOrder.checkoutBody.requestTaxaCampo?.lstCampos?.append(objeto)
            }
        }

        QiwiOrder.setTransitionAndValue(value: response.Valor_Taxa)
        QiwiOrder.productName = response.Nome
        QiwiOrder.setPrvId(prvId: response.Id_Prv)
        
        ListGenericViewController.stepListGeneric = .SELECT_PAYMENT
        completion()
    }
    
    func mountStatusForm(with form: [GetFormsResponse], completion: @escaping (() -> Void)) {
        for item in form.filter({ $0.Id_Formulario == idFormSaved }) {
            if item.Id_Status == 4 {
                completion()
            } else {
                
            }
        }
    }
}
