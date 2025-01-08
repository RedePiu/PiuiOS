import UIKit

public extension UIStackView {
    func removeAllArrangedSubviews() {
        // Remove all the arranged subviews and save them to an array
        let removedSubviews = arrangedSubviews.reduce([]) { (sum, next) -> [UIView] in
            self.removeArrangedSubview(next)
            return sum + [next]
        }

        // Deactive all constraints at once
        NSLayoutConstraint.deactivate(removedSubviews.flatMap { $0.constraints })

        // Remove the views from self
        removedSubviews.forEach {
            $0.superview?.sendSubview(toBack: $0)
            $0.isHidden = true
            $0.removeFromSuperview()
        }
    }

    func addArrangedSubviews(views: [UIView]) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}
