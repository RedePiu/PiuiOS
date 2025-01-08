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
        setupNavigationBar()
    }
    
    deinit {
        self.forms.removeAll()
        self.typeCard.removeAll()
    }
}

// MARK: - Private Functions
private extension ListItemsViewController {
    func getDataFromViewModel() {
        viewModel.getAllCardType(idEmissor: idEmissor) { typeCard in
            self.typeCard = typeCard
        }
        
        viewModel.getAllForms(idEmissor: idEmissor, cpf: Constants.cpfTaxa) { (forms, campos) in
            self.createItemCell(from: forms, campos: campos, typeCard: self.typeCard)
        }
    }
    
    func createItemCell(
        from response: [GetFormsResponse],
        campos: [CampoFormResponse],
        typeCard: [MenuCardTypeResponse]
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            for (i, item) in response.unique().enumerated() {
                let cellItem = SelectableItem()
                guard let type = typeCard.filter({ $0.Id_Tipo_Formulario_Carga == item.Id_Tipo_Carga }).first else { return }
                cellItem.itemTitle.text = "\(type.Nome) \(item.Via)a - \(item.Status)"
                cellItem.itemDescription.text = "\(item.Motivo)"
                
                print("@! >>> cell_item ", item)
                
                switch item.Id_Tipo_Carga {
                case 1:
                    self.navTitle = "transport_students_toolbar".localized
                case 2:
                    self.navTitle = "transport_card_type_common".localized
                default:
                    break
                }
                
                cellItem.actionButton.didTap = { [weak self] in
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
                baseView.stackView.subviews.forEach { $0.height(min: 40) }
            }
        }
    }
}

extension Sequence where Element: Hashable {
    func unique() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
