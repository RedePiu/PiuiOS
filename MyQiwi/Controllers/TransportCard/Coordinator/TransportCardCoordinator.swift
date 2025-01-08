import UIKit
import ObjectMapper

final class TransportCardCoordinator: Coordinator {
    
    // MARK: - Properties
    var baseRN: BaseRN?
    weak var taxaCardRN: TaxaCardRN?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    // MARK: - Constructor
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public required convenience init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    // MARK: - Start
    func start() {
        let controller = TaxaCardViewController()
        navigationController.present(controller, animated: true)
    }
    
    // MARK: - Controllers Navigation
    func startCPFConsult() {
        guard let baseRN else { return }
        let controller = CPFConsultFactory().start(with: baseRN)
        controller.taxaCardRN = taxaCardRN
        self.navigationController.pushViewController(controller, animated: true)
    }
    
}
