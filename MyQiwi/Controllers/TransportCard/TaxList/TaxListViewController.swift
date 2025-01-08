import UIKit

final class TaxListViewController: BaseViewController<TaxListView> {
    // MARK: - Properties
    private let viewModel: TaxListViewModel
    private lazy var taxaCardRN = TaxaCardRN(delegate: self)
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    private var completion: (() -> Void)
    
    private var getForms = [GetFormsResponse]()
    private let getTaxas: [GetTaxasResponse]
    
    // MARK: - View Lifecycle
    init(viewModel: TaxListViewModel, taxas: [GetTaxasResponse], completion: @escaping (() -> Void)) {
        self.viewModel = viewModel
        self.getTaxas = taxas
        self.completion = completion
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        taxaCardRN.getFormsResponses(idEmissor: produtoProdata.id_emissor, cpf: Constants.cpfTaxa)
//        taxaCardRN.getTaxaResponses(idEmissor: produtoProdata.id_emissor)
        
        viewModel.createItemCell(
            with: taxaCardRN.getAllGetTaxas(),
            stack: baseView.taxesStack
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigationBar(with: "transport_students_toolbar".localized)
    }
}


// MARK: - BaseDelegate
extension TaxListViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if result {
                self.endEditionAndDismiss()
                
                switch param {
                case Param.Contact.TAXA_GET_TAXA_RESPONSE:
                    print("@! >>> TAXA_GET_TAXA_RESPONSE...")
                    self.completion = {
                        self.viewModel.createItemCell(
                            with: self.taxaCardRN.getAllGetTaxas(),
                            stack: self.baseView.taxesStack
                        )
                    }
                    break
                case Param.Contact.TAXA_GET_CAMPO_TAXA_RESPONSE:
//                    itemCell.didTap = {
//                        self.navigateToPayments(object as! GetTaxasResponse)
//                    }
                    break
                default:
                    break
                }
            }
        }
    }
}

// MARK: - Private Functions
private extension TaxListViewController {
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        Util.showLoading(self)
        
        guard let cell = sender.view else { return }
        let taxa = getTaxas.filter({ $0.Id_Taxa == cell.tag }).first
        
        if taxa != nil {
            taxaCardRN.getCamposTaxaResponses(taxa: taxa!)
        }
        
        self.navigateToStoryboard("TaxaCard", withIdentifier: "ListGeneric")
    }
}
