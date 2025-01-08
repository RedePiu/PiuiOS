import UIKit

// MARK: - UIView Extensions

fileprivate var ak_ViewSpinner: UInt8 = 0

public extension UIView {
    
    // MARK: Public variables
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            
            return layer.cornerRadius
        }
        set {
            
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            
            return layer.borderWidth
        }
        set {
            
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        
        get {
            
            return UIColor.init(cgColor: layer.borderColor!)
        }
        set {
            
            layer.borderColor = newValue.cgColor
        }
    }
    
    var frameHeight: CGFloat {
        
        get {
            
            return self.frame.size.height
        }
        
        set (v) {
            
            var fra = self.frame
            fra.size.height = v
            self.frame = fra
        }
    }
    
    var frameOrigin: CGPoint {
        
        get {
            
            return self.frame.origin
        }
        
        set (v) {
            
            var fra = self.frame
            fra.origin = v
            self.frame = fra
        }
    }
    
    var frameSize: CGSize {
        
        get {
            
            return self.frame.size
        }
        
        set (v) {
            
            var fra = self.frame
            fra.size = v
            self.frame = fra
        }
    }
    
    var frameWidth: CGFloat {
        
        get {
            
            return self.frame.size.width
        }
        
        set (v) {
            
            var fra = self.frame
            fra.size.width = v
            self.frame = fra
        }
    }
    
    var frameX: CGFloat {
        
        get {
            
            return self.frame.origin.x
        }
        
        set (v) {
            
            var fra = self.frame
            fra.origin.x = v
            self.frame = fra
        }
    }
    
    var frameY: CGFloat {
        
        get {
            
            return self.frame.origin.y
        }
        
        set (v) {
            
            var fra = self.frame
            fra.origin.y = v
            self.frame = fra
        }
    }
    
    // MARK: Initializers
    
    convenience init(background: UIColor) {
        
        self.init()
        backgroundColor = background
    }
    
    // MARK: Public methods
    
    func roundCorners(_ corners: UIRectCorner?, radius: CGFloat) {
        
        if #available(iOS 11.0, *) {
            
            guard let corners = corners else {
                
                self.layer.maskedCorners = []
                return
            }
            
            var newCorners = CACornerMask()
            if corners.contains(.topRight) {
                
                newCorners.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.topLeft) {
                
                newCorners.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.bottomRight) {
                
                newCorners.insert(.layerMaxXMaxYCorner)
            }
            if corners.contains(.bottomLeft) {
                
                newCorners.insert(.layerMinXMaxYCorner)
            }
            
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = newCorners
        }
        else {
            
            if let corners = corners {
                
                let path = UIBezierPath(
                    roundedRect: bounds,
                    byRoundingCorners: corners,
                    cornerRadii: CGSize(width: radius,
                                        height: radius
                    )
                )
                
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                layer.mask = mask
            } else {
                
                layer.mask = nil
            }
        }
    }
    
    func asImage() -> UIImage {
        
        var image: UIImage?
        
        if frame.size.equalTo(CGSize.zero) {
            
            debugPrint("\(#function) frame.size is (0,0)")
        }
        else {
            
            UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
            
            if let ctx = UIGraphicsGetCurrentContext() {
                
                layer.render(in: ctx)
                image = UIGraphicsGetImageFromCurrentImageContext()
            }
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    func layoutIfNeededAffecting(_ axis: NSLayoutConstraint.Axis) {
        
        var set = Set<UIView>()
        
        constraintsAffectingLayout(for: axis)
            .map { [$0.secondItem as? UIView, $0.firstItem as? UIView] }
            .flatMap { $0 }
            .compactMap { $0 }
            .filter { isDescendant(of: $0) }
            .forEach { set.insert($0) }
        
        set.forEach { $0.layoutIfNeeded() }
    }
    
    func rotate(angle: CGFloat) {
        
        let radians = angle / 180.0 * CGFloat(Double.pi)
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
    
    class func animateWithDefaultDuration(_ animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration), animations: animations, completion: completion)
    }
    
    // MARK: - Anchors enums
    
    enum ComplexAnchor {
        case greater
        case less
    }
    
    enum AnchorType {
        case top
        case bottom
        case leading
        case trailing
        case heigth
        case width
        case centerX
        case centerY
    }
    
    // MARK: - Anchors extensions

    func applyAnchors(ofType: [AnchorType], to referenceView: UIView) {
        
        if ofType.contains(.bottom) {
            self.bottomAnchor.constraint(equalTo: referenceView.bottomAnchor).isActive = true
        }
        
        if ofType.contains(.top) {
            self.topAnchor.constraint(equalTo: referenceView.topAnchor).isActive = true
        }
        
        if ofType.contains(.trailing) {
            self.trailingAnchor.constraint(equalTo: referenceView.trailingAnchor).isActive = true
        }
        
        if ofType.contains(.leading) {
            self.leadingAnchor.constraint(equalTo: referenceView.leadingAnchor).isActive = true
        }
        
        if ofType.contains(.heigth) {
            self.heightAnchor.constraint(equalTo: referenceView.heightAnchor).isActive = true
        }
        
        if ofType.contains(.width) {
            self.widthAnchor.constraint(equalTo: referenceView.widthAnchor).isActive = true
        }
        
        if ofType.contains(.centerX) {
            self.centerXAnchor.constraint(equalTo: referenceView.centerXAnchor).isActive = true
        }
        if ofType.contains(.centerY) {
            self.centerYAnchor.constraint(equalTo: referenceView.centerYAnchor).isActive = true
        }
    }
    
    @discardableResult
    func top(to: NSLayoutYAxisAnchor,
                    padding: CGFloat = 0.0 ,
                    type: ComplexAnchor? = nil,
                    priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        if let type = type {
            switch type {
            case .greater:
                constraint = self.topAnchor.constraint(greaterThanOrEqualTo: to,
                                                       constant: padding)
            case .less:
                constraint = self.topAnchor.constraint(lessThanOrEqualTo: to,
                                                       constant: padding)
            }
        } else {
            constraint = self.topAnchor.constraint(equalTo: to, constant: padding)
        }
        constraint.priority = priority
        constraint.isActive = true
        
        return constraint
    }
    
    @discardableResult
    func bottom(to: NSLayoutYAxisAnchor,
                       padding: CGFloat = 0.0,
                       type: ComplexAnchor? = nil,
                       priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        if let type = type {
            switch type {
            case .greater:
                constraint = self.bottomAnchor.constraint(greaterThanOrEqualTo: to,
                                                          constant: padding)
            case .less:
                constraint = self.bottomAnchor.constraint(lessThanOrEqualTo: to,
                                                          constant: -(padding))
            }
        } else {
            constraint = self.bottomAnchor.constraint(equalTo: to, constant: -(padding))
        }
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func leadingAndTrailing(
            to view: UIView,
            padding: CGFloat = 0.0,
            type: ComplexAnchor? = nil,
            priority: UILayoutPriority = .required
        ) -> (
            leading: NSLayoutConstraint,
            trailing: NSLayoutConstraint
        ) {
            
            let leading = self.leading(to: view.leadingAnchor,
                                       padding: padding,
                                       type: type,
                                       priority: priority)
            let trailing = self.trailing(to: view.trailingAnchor,
                                         padding: padding,
                                         type: type,
                                         priority: priority)
            return (leading, trailing)
    }
    
    @discardableResult
    func leading(to: NSLayoutXAxisAnchor,
                        padding: CGFloat = 0.0,
                        type: ComplexAnchor? = nil,
                        priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        if let type = type {
            switch type {
            case .greater:
                constraint = self.leadingAnchor.constraint(greaterThanOrEqualTo: to,
                                                           constant: padding)
            case .less:
                constraint = self.leadingAnchor.constraint(lessThanOrEqualTo: to,
                                                           constant: padding)
            }
        } else {
            constraint = self.leadingAnchor.constraint(equalTo: to,
                                                       constant: padding)
        }
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func trailing(to: NSLayoutXAxisAnchor,
                         padding: CGFloat = 0.0,
                         type: ComplexAnchor? = nil,
                         priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        if let type = type {
            switch type {
            case .greater:
                constraint = self.trailingAnchor.constraint(greaterThanOrEqualTo: to,
                                                            constant: padding)
            case .less:
                constraint = self.trailingAnchor.constraint(lessThanOrEqualTo: to,
                                                            constant: -(padding))
            }
        } else {
            constraint = self.trailingAnchor.constraint(equalTo: to,
                                                        constant: -(padding))
        }
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerX(to: UIView, padding: CGFloat? = 0,
                 priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        constraint = centerXAnchor.constraint(equalTo: to.centerXAnchor,
                                              constant: padding ?? 0)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerY(to: UIView, padding: CGFloat? = nil,
                 priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        constraint = centerYAnchor.constraint(equalTo: to.centerYAnchor,
                                              constant: padding ?? 0)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func sized(with width: CGFloat, height: CGFloat) {
        
        sized(with: CGSize(width: width, height: height))
    }
    
    func sized(with size: CGSize) {
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
    }
    
    @discardableResult
    func height(size: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        constraint = heightAnchor.constraint(equalToConstant: size)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func height(min: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: min)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func width(size: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        constraint = widthAnchor.constraint(equalToConstant: size)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func width(min: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: min)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
    
    func anchors(equalTo view: UIView) {
        
        self.applyAnchors(ofType: [.top, .bottom, .leading, .trailing], to: view)
    }
    
    func center(to view: UIView) {
        
        self.applyAnchors(ofType: [.centerX, .centerY], to: view)
    }
    
    func findConstraint(layoutAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        if let constraints = superview?.constraints {
            for constraint in constraints where itemMatch(constraint: constraint, layoutAttribute: layoutAttribute) {
                return constraint
            }
        }
        return nil
    }
    
    func itemMatch(constraint: NSLayoutConstraint, layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        if let firstItem = constraint.firstItem as? UIView, let secondItem = constraint.secondItem as? UIView {
            let firstItemMatch = firstItem == self && constraint.firstAttribute == layoutAttribute
            let secondItemMatch = secondItem == self && constraint.secondAttribute == layoutAttribute
            return firstItemMatch || secondItemMatch
        }
        return false
    }
    
    func value(of axis: axisYPosition, relatedTo reference: UIView) -> CGFloat {
        
        switch axis {
        case .maxY:
            return reference.convert(self.frame, from: self.superview).maxY
        case .minY:
            return reference.convert(self.frame, from: self.superview).minY
        }
    }
}

public enum axisYPosition {
    case maxY
    case minY
}
