import UIKit

final class NoticeViewController: BaseViewController<NoticeView> {
    
    // MARK: - Properties
    private let viewTitle: String
    
    // MARK: - View Lifecycle
    init(navigationTitle: String, contentTitle: String, contentDescription: String, contentImage: String, completion: (() -> Void)?) {
        self.viewTitle = navigationTitle
        super.init()
        baseView.titleLabel.text = contentTitle
        baseView.descriptionLabel.text = contentDescription
        baseView.contentImageView.image = UIImage(named: contentImage)
        completion?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigationBar(with: viewTitle, hasBack: false)
    }
}
