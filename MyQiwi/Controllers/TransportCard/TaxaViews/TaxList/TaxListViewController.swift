import UIKit

final class TaxListViewController: BaseViewController<TaxListView> {
    // MARK: - Properties
    private let viewModel: TaxListViewModel
    private lazy var taxaCardRN = TaxaCardRN(delegate: self)
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    
    private var getForms = [GetFormsResponse]()
    private var idForm = Int()
    private var viaForm = Int()
    private var idCarga = Int()
    
    // MARK: - View Lifecycle
    init(viewModel: TaxListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taxaCardRN.getFormsResponses(
            idEmissor: produtoProdata.id_emissor,
            cpf: Constants.cpfTaxa
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //setupNavigationBar(with: "transport_card_tax_payment".localized)
        setupNavigationTitle(from: taxaCardRN.getAllGetTaxas())
    }
    
    deinit {
        self.getForms.removeAll()
    }
}

// MARK: - BaseDelegate
extension TaxListViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            switch param {
            case Param.Contact.TAXA_GET_FORM_RESPONSE:
                if result {
                    if let tipoCarga = taxaCardRN.getAllGetForms().map({ $0.Id_Tipo_Carga }).first {
                        self.idCarga = tipoCarga
                    }
                    
                    for item in taxaCardRN.getAllGetForms() {
                        self.idForm = item.Id_Formulario
                        self.viaForm = item.Via
                    }
                    self.getForms.append(contentsOf: taxaCardRN.getAllGetForms())
                    self.createItemCell(with: self.taxaCardRN.getAllGetTaxas())
                    self.endEditionAndDismiss()
                }
            case Param.Contact.TAXA_GET_CAMPO_TAXA_RESPONSE:
                self.viewModel.orderPayments(object as! GetTaxasResponse, idCarga: idCarga, idForm: idForm) {
                    self.navigateToStoryboard("TaxaCard", withIdentifier: "ListGeneric")
                }
            default:
                break
            }
        }
    }
}

//34805841877

// MARK: - Private Functions
private extension TaxListViewController {
    func createItemCell(with taxes: [GetTaxasResponse]) {
        
        print("@! >>> Taxas_Sem_Filtro ", taxes, "\n\n\n")
        print("@! >>> idCarga ", idCarga, "\n\n\n")
        
        let filterTaxes = taxes.filter({
            $0.Tipo_Formulario == idCarga && $0.Via == viaForm
        })
        
        print("@! >>> Taxas_Filtradas ", filterTaxes, "\n\n\n")
        
        let format = NumberFormatter()
        format.numberStyle = .currency
        format.currencySymbol = "R$"
        
        for item in filterTaxes {
            print("@! >>> ITEM: ", item)
            
            let cell = TitledDescriptionRow()
            cell.tag = item.Id_Taxa
            cell.titleLabelView.text = item.Nome
            cell.descriptionLabel.text = format.string(from: NSNumber(value: Int(item.Valor_Taxa)) ) ?? "R$0,00"
            cell.didTap = { [weak self] in
                guard let self,
                      let taxa = self.taxaCardRN.getAllGetTaxas().filter({
                    $0.Id_Taxa == cell.tag
                }).first else { return }
                self.taxaCardRN.getCamposTaxaResponses(taxa: taxa)
            }
            baseView.taxesStack.addArrangedSubviews(views: [cell])
        }
    }
    
    func setupNavigationTitle(from form: [GetTaxasResponse]) {
        for item in form {
            switch item.Tipo_Formulario {
            case 1, 2, 3, 4:
                self.setupNavigationBar(with: "transport_card_tax_payment".localized)
            case 5:
                self.setupNavigationBar(with: "transport_card_type_common".localized)
            case 6:
                self.setupNavigationBar(with: "transport_students_toolbar".localized)
            default:
                break
            }
        }
    }
}
