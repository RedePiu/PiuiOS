import UIKit

final class ListItemsViewController: BaseViewController<ListItemsView> {
    
    // MARK: - Properties
    private let baseRN: TaxaCardRN?
    private let viewModel: ListItemsViewModel
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    private var forms = [GetFormsResponse]()
    private var campoForm = [CampoFormResponse]()
    private var typeCard = [MenuCardTypeResponse]()
    
    private var typeName = String()
    private var navTitle = String()
    
    // MARK: - View Lifecycle
    init(viewModel: ListItemsViewModel, forms: [GetFormsResponse], baseRN: TaxaCardRN) {
        self.viewModel = viewModel
        self.forms = forms
        self.baseRN = baseRN
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromViewModel()
        setupTableView()
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

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ListItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SelectableItem else {
            return UITableViewCell()
        }
        let item = forms[indexPath.row]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            guard let self else { return }
            cell.itemTitle.text = "\(typeName) - \(item.Via)a via"
            cell.itemDescription.text = "\(item.Status)"
            cell.itemComment.text = "\(item.Motivo)"
            cell.backgroundColor = .clear
            
            let cellSize = CGSize(
                width: 200,
                height: 120
            )
            cell.selectedBackgroundView?.translatesAutoresizingMaskIntoConstraints = false
            cell.selectedBackgroundView?.frame.size = cellSize
            cell.selectedBackgroundView?.backgroundColor = .red
            
            self.baseView.tableView.isHidden = false
            self.baseView.activityIndicator.stopAnimating()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = forms[indexPath.row]
        setupNavBarTitle(from: item)
        
        guard let baseRN else { return }
        switch item.Id_Status {
        case 3:
            showLoading(self) { [weak self] in
                guard let self else { return }
                self.pushViewController(
                    CardUserFormFactory().start(
                        with: item,
                        campos: baseRN.getAllCamposForm(),
                        baseRN: baseRN
                    )
                )
            }
        case 4:
            showLoading(self) { [weak self] in
                guard let self else { return }
                self.pushViewController(
                    TaxListFactory().start(with: baseRN, cpf: Constants.cpfTaxa)
                )
            }
        default:
            displayNoticeView(
                navTitle: navTitle,
                title: item.Status,
                description: item.Motivo,
                image: "img_student3",
                btnTitle: "Fechar"
            )
        }
    }
}

// MARK: - Private Functions
private extension ListItemsViewController {
    func setupTableView() {
        baseView.tableView.delegate = self
        baseView.tableView.dataSource = self
        baseView.tableView.register(SelectableItem.self, forCellReuseIdentifier: "cell")
    }
    
    func setupNavBarTitle(from item: GetFormsResponse) {
        switch item.Id_Tipo_Carga {
        case 1:
            self.navTitle = "transport_students_toolbar".localized
        case 2:
            self.navTitle = "transport_card_type_common".localized
        default:
            break
        }
    }
    
    func getDataFromViewModel() {
        viewModel.getAllCardType(idEmissor: produtoProdata.id_emissor) { [weak self] typeCard in
            guard let self else { return }
            self.typeCard = typeCard
            
            DispatchQueue.main.async {
                for form in self.forms {
                    guard let type = typeCard.filter({
                        $0.Id_Tipo_Formulario_Carga == form.Id_Tipo_Carga
                    }).first else { return }
                    self.typeName = type.Nome
                }
            }
        }
    }
}
