import UIKit

final class NewCardViewController: BaseViewController<NewCardView> {
    
    // MARK: - Properties
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    private lazy var taxaCardRN = TaxaCardRN(delegate: self)
    private var menuCardTypes: [MenuCardTypeResponse]
    private var taxaCards = [TaxaCardResponse]()
    private var getForms = [GetFormsResponse]()
    private var layoutForm = [LayoutFormResponse]()
    private var idFormSaved = 0
    
    init(menuCardTypes: [MenuCardTypeResponse]) {
        self.menuCardTypes = menuCardTypes
        super.init()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCards()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigationBar()
    }
}

extension NewCardViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {}
}

private extension NewCardViewController {
    func setupCards() {
        self.taxaCards = taxaCardRN.getAllCards()
        
        for card in menuCardTypes {
            let cartao = self.taxaCards.filter({return Int($0.codCarga) == Int(card.codCarga)}).first
            
            if cartao == nil {
                let button = MainButton(type: .primary, title: card.Nome)
                button.tag = card.Id_Tipo_Formulario_Carga
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                baseView.buttonsStack.addArrangedSubview(button)
            }
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        Util.showLoading(self)
        Constants.idTipoCarga = sender.tag
        Constants.viaCarga = 1
        taxaCardRN.getLayoutFormResponses(
            idEmissor: produtoProdata.id_emissor,
            id_tipo_formulario_carga: Constants.idTipoCarga,
            via: Constants.viaCarga,
            fl_dependente: false
        )
        
        print("@! >>> SENDER.TAG ", Constants.idTipoCarga)
        
        //self.pushViewController(CardUserFormViewController(viewModel: CardUserFormViewModel()))
        self.navigateToStoryboard("TaxaCard", withIdentifier: "TaxaLayoutFormViewController")
    }
}
