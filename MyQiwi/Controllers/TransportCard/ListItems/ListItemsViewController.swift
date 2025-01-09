import UIKit

final class ListItemsViewController: BaseViewController<ListItemsView> {
    
    // MARK: - Properties
    weak var coordinator: TransportCardCoordinator?
    var baseRN: BaseRN?
    private let viewModel: ListItemsViewModel
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    private var forms = [GetFormsResponse]()
    private var campoForm = [CampoFormResponse]()
    private var typeCard = [MenuCardTypeResponse]()
    private lazy var idEmissor = produtoProdata.id_emissor
    private var navTitle = String()
    
    // MARK: - View Lifecycle
    init(viewModel: ListItemsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDataFromViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigationBar(with: "solicitar_cartao_nav_title".localized)
    }
    
    deinit {
        self.forms.removeAll()
        self.typeCard.removeAll()
    }
}

// MARK: - Private Functions
private extension ListItemsViewController {
    func getDataFromViewModel() {
        baseView.activityIndicator.isHidden = false
        
        viewModel.getAllCardType(idEmissor: idEmissor) { typeCard in
            self.typeCard = typeCard
        }
        
        viewModel.getAllForms(idEmissor: idEmissor, cpf: Constants.cpfTaxa) { [weak self] (forms, campos) in
            guard let self else { return }
            self.createItemCell(from: forms, campos: campos, typeCard: self.typeCard)
            self.baseView.activityIndicator.isHidden = true
        }
    }
    
    func createItemCell(
        from response: [GetFormsResponse],
        campos: [CampoFormResponse],
        typeCard: [MenuCardTypeResponse]
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let list = response.unique(from: response).last else {
                return
            }
            
            var forms = [GetFormsResponse]()
            forms.append(list)
            
            for (i, item) in forms.enumerated() {
                let cellItem = SelectableItem()

                guard let type = typeCard.filter({ $0.Id_Tipo_Formulario_Carga == item.Id_Tipo_Carga }).first else {
                    return
                }
                cellItem.itemTitle.text = "\(type.Nome) - \(item.Via)a via"
                cellItem.itemDescription.text = "\(item.Status)"
                cellItem.itemComment.text = "\(item.Motivo)"
        
                switch item.Id_Tipo_Carga {
                case 1:
                    self.navTitle = "transport_students_toolbar".localized
                case 2:
                    self.navTitle = "transport_card_type_common".localized
                default:
                    break
                }
                
                cellItem.didTap = { [weak self] in
                    guard let self else { return }
                    let indexPath = campos.index(i, offsetBy: 0)
                    
                    switch item.Id_Status {
                    case 1, 2, 5, 6, 7, 8, 9:
                        self.displayNoticeView(
                            navTitle: navTitle,
                            title: item.Status,
                            description: item.Motivo,
                            image: "img_student3",
                            btnTitle: "Fechar"
                        )
                    case 3:
                        self.showLoading(self) {
                            if let baseRN = self.baseRN, indexPath == i {
                                self.pushViewController(
                                    CardUserFormFactory().start(
                                        with: item, campos: campos, baseRN: baseRN
                                    )
                                )
                            }
                        }
                    case 4:
                        self.showLoading(self) {
                            if let baseRN = self.baseRN {
                                self.pushViewController(
                                    TaxListFactory().start(with: baseRN, cpf: Constants.cpfTaxa)
                                )
                            }
                        }
                    default:
                        break
                    }
                }
                
                baseView.stackView.addArrangedSubview(cellItem)
                cellItem.translatesAutoresizingMaskIntoConstraints = false
                cellItem.leadingAndTrailing(to: baseView.stackView, padding: 24)
                cellItem.height(min: cellItem.mainContainer.frameHeight + 70)
                baseView.stackView.arrangedSubviews.forEach {
                    $0.top(to: $0.bottomAnchor, padding: 20)
                }
            }
        }
    }
}
