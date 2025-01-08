import UIKit

// MARK: - NSLayoutConstraint extensions

public extension NSLayoutConstraint {
    
    // MARK: Public methods
    
    class func constraints(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        return visualFormat.split(separator: ";")
            .map {
                NSLayoutConstraint.constraints(withVisualFormat: String($0), options: [], metrics: metrics, views: views)
            }.flatMap{$0}
    }
    
    @discardableResult class func activate(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        let arr = visualFormat
            .split(separator: ";")
            .map { NSLayoutConstraint.constraints(String($0), views: views, metrics: metrics) }
            .flatMap{$0}
                
        NSLayoutConstraint.activate(arr)
        return arr
    }
    
    class func equalConstraints(_ attribute: [NSLayoutConstraint.Attribute], to: Any?, constant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        var arr: [NSLayoutConstraint] = []
        for att in attribute {
            
            arr.append(NSLayoutConstraint(item: self, attribute: att, relatedBy: NSLayoutConstraint.Relation.equal, toItem: to, attribute: att, multiplier: 1, constant: constant))
        }
        return arr
    }
    
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        
        self.priority = priority
        return self
    }
    
    class func constraintsInlineBetween(views: [UIView], space: CGFloat, axis: NSLayoutConstraint.Axis) {
        
        if views.isEmpty { return }
        
        var cons = axis == .horizontal ? "H:" : "V:"
        var i = 0
        var dict = [String:Any]()
        for obj in views {
            
            let key = "v\(i)"
            dict[key] = obj
            cons += "[\(key)]"
            if i < views.count-1 {
                cons += "-space-"
            }
            i+=1
        }
        activate(cons, views: dict, metrics: ["space":space])
    }
    
    class func equalSpacesInlineBetween(views: [UIView], superview: UIView, axis: NSLayoutConstraint.Axis, minSpace: CGFloat, from: Any? = nil, to: Any? = nil) {
        
        var attTo = NSLayoutConstraint.Attribute.bottom
        var attFrom = NSLayoutConstraint.Attribute.top
        var attSize = NSLayoutConstraint.Attribute.height
        
        if axis == .horizontal {
            attTo = .trailing
            attFrom = .leading
            attSize = .width
        }
        
        if views.count > 0 {
            
            var prev = UIView()
            
            if let from = from {
                superview.addSubview(prev, constraints: true)
                prev.equalConstraint(attFrom, to: from, attribute: (superview != (from as? UIView) ? attTo : attFrom), priority: UILayoutPriority.required.rawValue)
                prev.height(min: minSpace)
            }
            
            for v in views {
                
                let next = UIView()
                superview.addSubview(next, constraints: true)
                
                if prev.superview != nil {
                    v.equalConstraint(attFrom, to: prev, attribute: attTo, priority: UILayoutPriority.required.rawValue)
                    prev.equalConstraints([attSize], to: next)
                    next.equalConstraints([attSize], to: prev)
                }
                else {
                    if axis == .vertical {
                        next.height(min: minSpace)
                    }
                    else {
                        next.width(min: minSpace)
                    }
                }
                
                v.equalConstraint(attTo, to: next, attribute: attFrom, priority: UILayoutPriority.required.rawValue)
                
                prev = next
            }
            
            if let to = to {
                prev.equalConstraint(attTo, to: to, attribute: (superview != (to as? UIView) ? attFrom : attTo), priority: UILayoutPriority.required.rawValue)
            }
            else {
                prev.removeFromSuperview()
            }
        }
    }
}

// MARK: - UIView extensions

public extension UIView {
    
    // MARK: Public methods
    
    @discardableResult func activateConstraints(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        return NSLayoutConstraint.activate(visualFormat, views: views, metrics: metrics)
    }
    
    func addSubview(_ subview: UIView, constraints: Bool) {
        
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = !constraints
    }
    
    func addSubviews(_ subviews: [UIView], constraints: Bool) {
        
        for subview in subviews {
            
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = !constraints
        }
    }
    
    @discardableResult
    func equalConstraints(_ attribute: [NSLayoutConstraint.Attribute], to: Any?, constant: CGFloat = 0, priority: Float = 1000) -> [NSLayoutConstraint] {
        
        var arr: [NSLayoutConstraint] = []
        for att in attribute {
            
            arr.append(
                NSLayoutConstraint(
                    item: self,
                    attribute: att,
                    relatedBy: NSLayoutConstraint.Relation.equal,
                    toItem: to,
                    attribute: att,
                    multiplier: 1,
                    constant: constant)
                    .withPriority(UILayoutPriority(rawValue: priority)))
        }
        
        if arr.isEmpty == false {
            
            NSLayoutConstraint.activate(arr)
        }
        return arr
    }
    
    @discardableResult
    func equalConstraint(_ from: NSLayoutConstraint.Attribute, to: Any?, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0, priority: Float = 1000) -> NSLayoutConstraint {
        
        let cons = NSLayoutConstraint(
            item: self,
            attribute: from,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: to,
            attribute: attribute,
            multiplier: 1,
            constant: constant
        ).withPriority(UILayoutPriority(rawValue: priority))
        cons.isActive = true
        return cons
    }
    
    @discardableResult func equalConstraint(_ from: NSLayoutConstraint.Attribute, to: Any?, attribute: NSLayoutConstraint.Attribute, constant: CGFloat = 0, priority: UILayoutPriority) -> NSLayoutConstraint {
        
        let cons = NSLayoutConstraint(
            item: self,
            attribute: from,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: to,
            attribute: attribute,
            multiplier: 1,
            constant: constant
            ).withPriority(priority)
        cons.isActive = true
        return cons
    }
}

// MARK: - UIViewController extensions

public extension UIViewController {
    
    // MARK: Public methods
    
    @discardableResult func activateConstraints(_ visualFormat: String, views: [String : Any], metrics: [String : Any]? = nil) -> [NSLayoutConstraint] {
        
        return NSLayoutConstraint.activate(visualFormat, views: views, metrics: metrics)
    }
    
    func addScrollView(_ scrollView: UIScrollView, contentView: UIView, top: Any? = nil, bottom: Any? = nil) {
        
        view.addSubview(scrollView, constraints: true)
        scrollView.addSubview(contentView, constraints: true)
        var dict: [String:Any] = ["sv":scrollView, "cont" : contentView]
        if let top = top { dict["top"] = top }
        if let bottom = bottom { dict["bot"] = bottom }
        activateConstraints("H:|[sv]|", views: dict)
        activateConstraints(top != nil ? "V:[top][sv]" : "V:|[sv]", views: dict)
        activateConstraints(bottom != nil ? "V:[sv][bot]" : "V:[sv]|", views: dict)
        activateConstraints("V:|[cont]->=0-|", views: dict)
        activateConstraints("H:|[cont(sv)]|", views: dict)
    }
}

// MARK: - UIScrollView extensions

public extension UIScrollView {
    
    // MARK: Public methods
    
    func addConstrainedSubviews(_ subviews:[UIView]) {
        
        var dict: [String:Any] = ["sv":self]
        for v in subviews {
            
            v.translatesAutoresizingMaskIntoConstraints = false
            addSubview(v)
            dict["v"] = v
            activateConstraints("V:|[v(==sv)]|", views: dict)
            activateConstraints("H:[v(==sv)]", views: dict)
            
            if dict["prev"] == nil {
                
                activateConstraints("H:|[v]", views: dict)
            }
            else {
                
                activateConstraints("H:[prev]-0@250-[v]", views: dict)
            }
            
            if v == subviews.last {
                
                activateConstraints("H:[v]|", views: dict)
            }
            dict["prev"] = v
        }
    }
}
