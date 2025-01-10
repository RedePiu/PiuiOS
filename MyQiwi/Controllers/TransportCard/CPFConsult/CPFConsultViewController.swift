import UIKit

final class CPFConsultViewController: BaseViewController<CPFConsultView> {
    
    // MARK: - Properties
    weak var taxaCardRN: TaxaCardRN?
    var baseRN: BaseRN
    private let viewModel: CPFConsultViewModel
    
    private var forms = [GetFormsResponse]()
    private var cards = [TaxaCardResponse]()
    private lazy var cpf = baseView.cpfInputView.text ?? ""
    private let produtoProdata = ProdutoProdataDAO().getByPrv(prvid: QiwiOrder.selectedMenu.prvID)
    
    // MARK: - View Lifecycle
    init(viewModel: CPFConsultViewModel, baseRN: BaseRN) {
        self.viewModel = viewModel
        self.baseRN = baseRN
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBottomButtons()
        getFormsFromViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigationBar(with: QiwiOrder.selectedMenu.desc)
    }
}

// MARK: - Private functions
private extension CPFConsultViewController {
    func getCardsFromViewModel() {
        viewModel.getCards(cpf: cpf.removeAllOtherCaracters()) { [weak self] card in
            guard let self else { return }
            self.cards.append(card)
        }
    }
    
    func getFormsFromViewModel() {
        
        baseView.cpfInputView.keyboardType = .numberPad
        
        viewModel.getForms(userCPF: cpf.removeAllOtherCaracters()) { [weak self] response in
            guard let self else { return }
            self.forms = response
            self.validateAndSetupCPF()
        }
    }
    
    func validateAndSetupCPF() {
        if Constants.cpfTaxa == "eu" {
            Constants.cpfTaxa = ""
            viewModel.getCpfData(valid: false) {
                self.verificarForm()
            }
        }
    }
    
    func verificarForm() {
        if Constants.fl_verifica_form {
            viewModel.getForms(userCPF: cpf.removeAllOtherCaracters()) { [weak self] response in
                guard let self else { return }
                self.forms = response
                
                if self.forms.isEmpty {
                    self.displayAlert(
                        title: "user_cpf_consult_list_status_error_title".localized,
                        description: "user_cpf_consult_list_status_error_description".localized
                    )
                } else {
                    Constants.cpfTaxa = self.baseView.cpfInputView.text!.removeAllOtherCaracters()
                    
                    guard let taxaCard = self.taxaCardRN else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.showLoading(self) {
                            self.pushViewController(ListItemsFactory().start(with: taxaCard))
                        }
                    }
                }
            }
        } else {
            viewModel.getCards(cpf: cpf.removeAllOtherCaracters()) { [weak self] card in
                guard let self else { return }
                self.cards.append(card)
                
                if let cpf = self.baseView.cpfInputView.text {
                    Constants.cpfTaxa = cpf.removeAllOtherCaracters()
                }
                self.showLoading(self) {
                    self.navigateToStoryboard("TaxaCard", withIdentifier: "TaxaListCardViewController")
                }
            }
        }
    }
    
    func setupBottomButtons() {
        baseView.backButton.setButtonAction = { [weak self] in
            guard let self else { return }
            self.popViewController()
        }
        
        baseView.continueButton.setButtonAction = { [weak self] in
            guard let self else { return }
            
            self.getCardsFromViewModel()
            print("@! >>> FORMS: ", self.forms)
            
            self.viewModel.getCpfData(valid: true, for: Constants.cpfTaxa.removeAllOtherCaracters()) {
                self.verificarForm()
            }
        }
    }
}
