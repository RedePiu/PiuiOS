//
//  View+Extension.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 05/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

extension UIView {
    
    func setupViewCard(radius: CGFloat = 3) {
        
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.roundCorners(radius: radius)
        self.layer.addShadow()
    }
    
    func setupViewWithoutCard() {
        
        self.backgroundColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }
    
    func changeVisibilityAfter(isHidden: Bool, after: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: {
            self.isHidden = isHidden
        })
    }
    
    func faddingAppearAnimation(after: Double, duration: Double = 1.5) {
           self.alpha = 0.0
           DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: {
               UIView.animate(withDuration: duration) {
                   self.alpha = 1.0
               }
           })
       }
       
    func faddingDissappearAnimation(after: Double, duration: Double = 1.5) {
       DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: {
           UIView.animate(withDuration: duration) {
               self.alpha = 0.0
           }
       })
    }
    
    func setBackgroundColor(color: UIColor, duration: Double = 0.5) {
        UIView.animate(withDuration: duration) {
            self.layer.backgroundColor = color.cgColor
        }
    }
    
    func setBackgroundColor(color: UIColor, after: Double, duration: Double = 0.5) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: {
            self.setBackgroundColor(color: color, duration: duration)
        })
    }
    
    func setScale(scale: Double) {
        self.transform = CGAffineTransform.identity.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
    }
    
    func hide(animation: Bool = true) {
        self.isHidden(true, animation: animation)
    }
    
    func show(animation: Bool = true) {
        self.isHidden(false, animation: animation)
    }
    
    func isHidden(_ hidden: Bool, animation: Bool = true) {
        
        if !animation {
            self.isHidden = hidden
            return
        }
        
        UIView.animate(withDuration: 0.4) {
            self.isHidden = hidden
        }
    }
    
    func scale(_ value: Double) {
        self.transform = CGAffineTransform.identity.scaledBy(x: CGFloat(value), y: CGFloat(value))
    }
    
    func doActionAfter(after: Double, completion: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: {
            completion?()
        })
    }
    
    func method(arg: Bool, completion: (Bool) -> ()) {
        print("First line of code executed")
        // do stuff here to determine what you want to "send back".
        // we are just sending the Boolean value that was sent in "back"
        completion(arg)
    }
    
    func scaleAppearAnimation(duration: Double = 1.2) {
        
    }
}

extension UIView {
    
    func setHeight(_ height: Double) -> UIView {
        self.frame = CGRect(x: 0, y: 0, width: Double(self.frame.width), height: height)
        return self
    }
    
    func setWidth(_ width: Double) -> UIView {
        self.frame = CGRect(x: 0, y: 0, width: width, height: Double(self.frame.height))
        return self
    }
}

extension UIView {
    
    func blinkAnimation(duration: TimeInterval = 1, delay: TimeInterval = 0.1, alpha: CGFloat = 0.2) {
        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            self.alpha = alpha
        })
    }
    
    func scaleIn(duration: Double = 1.3, delay: Double = 0) {
        
        self.scale(0)
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: duration, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            })
        }, completion: nil)
    }
    
    func scaleOut(duration: Double = 1.2, delay: Double = 0) {
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: duration-0.2, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
            })
        }, completion: nil)
    }
    
    @objc func bounce(rate:CGFloat = 30, duration: Double = 0.8){
           let currentCenter = center
           let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.8, animations: nil)
           animator.addAnimations({
               self.center.y -= rate
           }, delayFactor: 0)
           animator.addAnimations({
               self.center.y = currentCenter.y
           }, delayFactor: 0.4)
           animator.startAnimation()
       }
    
       func flash(loop: Bool = false, duration: Double = 0.5, delay: Double = 0){
           
           let animationOptions:UIView.AnimationOptions = loop ? [.autoreverse,.repeat] : [.autoreverse]
           UIView.animate(withDuration: duration, delay: delay, options: animationOptions, animations: {
               self.alpha = 0
           }) { (_) in
               self.alpha = 1
           }
       }
    
       func pulse(duration: Double = 0.5, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                   self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                   self.transform = .identity
               })
           }, completion: nil)
       }
    
    func rubberBand(xScale:CGFloat = 2, yScale: CGFloat = 0.7, duration: Double = 0.3, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                   self.transform = CGAffineTransform(scaleX: 1, y: yScale)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                   self.transform = CGAffineTransform(scaleX: xScale, y: yScale)
               })
           }) { (_) in
               UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
                   self.transform = .identity
               }, completion: nil)
           }
       }
       
       func swing(duration: Double = 1){
           //Use a better one
           let animation = CAKeyframeAnimation()
           animation.keyPath = "transform.rotation"
           animation.values = [0, 0.3, -0.3, 0.3, 0]
           animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
           animation.duration = CFTimeInterval(duration)
           animation.isAdditive = true
           animation.repeatCount = 1
           animation.beginTime = CACurrentMediaTime() + CFTimeInterval(0)
           layer.add(animation, forKey: "swing")
       }
    
    func rotate() { //CAKeyframeAnimation
            
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.duration = 8
            animation.fillMode = kCAFillModeForwards
            animation.repeatCount = .infinity
            animation.values = [0, Double.pi/2, Double.pi, Double.pi*3/2, Double.pi*2]
            //Percentage of each key frame
            animation.keyTimes = [NSNumber(value: 0.0), NSNumber(value: 0.1),
                                  NSNumber(value: 0.3), NSNumber(value: 0.8), NSNumber(value: 1.0)]
            
            self.layer.add(animation, forKey: "rotate")
    }
    
       func tada(duration: Double = 1.5, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6, animations: {
                   self.transform = CGAffineTransform(rotationAngle: 270).scaledBy(x: 0.7, y: 0.7)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3, animations: {
                   self.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.1, animations: {
                   self.transform = .identity
               })
           }) { (_) in
               
           }
       }
       
       func hearbeat(duration: Double = 1.5, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                   self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.16, relativeDuration: 0.2, animations: {
                   self.transform = .identity
               })
               UIView.addKeyframe(withRelativeStartTime: 0.32, relativeDuration: 0.2, animations: {
                   self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.64, relativeDuration: 0.2, animations: {
                   self.transform = .identity
               })
               UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2, animations: {
                   self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.96, relativeDuration: 0.2, animations: {
                   self.transform = .identity
               })
           }, completion: nil)
       }
       
       func jello(duration: Double = 1.5){
           //Needs improvement
           let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.3, animations: nil)
           animator.addAnimations({
               self.transform = CGAffineTransform(rotationAngle: 5.93412).scaledBy(x: 1.1, y: 1.1)
           }, delayFactor: 0)
           animator.addAnimations({
               self.transform = .identity
           }, delayFactor: 0.1)
           
           animator.addCompletion { (_) in
               self.jello()
           }
           animator.startAnimation()
       }
    
       //MARK-:Bounce Entrance Animations
       func bounceInDown(duration: Double = 1.5){
           let originalPoint = self.center.y
           self.center.y = -((self.superview?.frame.height)!)
           let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7, animations: nil)
           animator.addAnimations({
               self.center.y = originalPoint
           })
           animator.startAnimation()
       }
    
       func bounceInLeft(duration: Double = 2){
           let originalPoint = self.center.x
           self.center.x = -((self.superview?.frame.width)!)
           let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7, animations: nil)
           animator.addAnimations({
               self.center.x = originalPoint
           })
           animator.startAnimation()
       }
    
       func bounceInRight(duration: Double = 2){
           let originalPoint = self.center.x
           self.center.x = ((self.superview?.frame.width)!)
           let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7, animations: nil)
           animator.addAnimations({
               self.center.x = originalPoint
           })
           animator.startAnimation()
       }
    
       func bounceInUp(duration: Double = 2){
           let originalPoint = self.center.y
           self.center.y = ((self.superview?.frame.height)!)
           let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.7, animations: nil)
           animator.addAnimations({
               self.center.y = originalPoint
           })
           animator.startAnimation()
       }
       //MARK-:Bounce Exit Animations
       
       func bounceOut(duration: Double = 1.5, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                   self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3, animations: {
                   self.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
               })
               UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                   self.transform = CGAffineTransform(scaleX: 0, y: 0)
                   self.alpha = 0
               })
           }, completion: nil)
       }
       func bounceOutDown(duration: Double = 1.5, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                   self.center.y += 7
               })
               UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3, animations: {
                   self.center.y -= 14
               })
               UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                   self.center.y = ((self.superview?.frame.height)!) + self.frame.height
               })
           }, completion: nil)
       }
    
    func bounceOutLeft(duration: Double = 1.5, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                   self.center.x += 15
               })
               UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                   self.center.x = -(((self.superview?.frame.width)!) + self.frame.width)
               })
           }, completion: nil)
       }
    
       func bounceOutRight(duration: Double = 1.5, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                   self.center.x -= 15
               })
               UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                   self.center.x = (((self.superview?.frame.width)!) + self.frame.width)
               })
           }, completion: nil)
       }
    
       func bounceOutUp(duration: Double = 1.5, delay: Double = 0){
           UIView.animateKeyframes(withDuration: duration, delay: delay, options: [], animations: {
               UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3, animations: {
                   self.center.y -= 7
               })
               UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3, animations: {
                   self.center.y += 14
               })
               UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                   self.center.y = -((self.superview?.frame.height)!) + self.frame.height
               })
           }, completion: nil)
       }
    
       //FADE IN ANIMATIONS
       func fadeIn(duration: Double = 1.5){
           self.alpha = 0
           UIView.animate(withDuration: duration) {
               self.alpha = 1
           }
       }
    
       func fadeInDown(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.alpha = 0
           self.center.y -= 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.y = currentCenter.y
               self.alpha = 1
           }, completion: nil)
       }
    
       func fadeInDownBig(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.alpha = 0
           self.center.y -= self.superview?.frame.height ?? 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.y = currentCenter.y
               self.alpha = 1
           }, completion: nil)
       }
    
       func fadeInLeft(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.alpha = 0
           self.center.x -= 35
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.x = currentCenter.x
               self.alpha = 1
           }, completion: nil)
       }
    
       func fadeInLeftBig(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.alpha = 0
           self.center.x -= self.superview?.frame.width ?? 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.x = currentCenter.x
               self.alpha = 1
           }, completion: nil)
       }
    
       func fadeInRight(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.alpha = 0
           self.center.x += 35
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.x = currentCenter.x
               self.alpha = 1
           }, completion: nil)
       }
    
       func fadeInRightBig(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.alpha = 0
           self.center.x += self.superview?.frame.width ?? 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.x = currentCenter.x
               self.alpha = 1
           }, completion: nil)
       }
    
       func fadeInUp(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.alpha = 0
           self.center.y += 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.y = currentCenter.y
               self.alpha = 1
           }, completion: nil)
       }
    
       func fadeInUpBig(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.alpha = 0
           self.center.y += self.superview?.frame.height ?? 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.y = currentCenter.y
               self.alpha = 1
           }, completion: nil)
       }
       //FADE Out ANIMATIONS
       
       func fadeOut(duration: Double = 1.5){
           UIView.animate(withDuration: duration) {
               self.alpha = 0
           }
       }
    
       func fadeOutDown(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.center.y -= 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.y = currentCenter.y
               self.alpha = 0
           }, completion: nil)
       }
    
       func fadeOutDownBig(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.center.y -= self.superview?.frame.height ?? 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.y = currentCenter.y
               self.alpha = 0
           }, completion: nil)
       }
    
       func fadeOutLeft(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.center.x -= 35
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.x = currentCenter.x
               self.alpha = 0
           }, completion: nil)
       }
    
       func fadeOutLeftBig(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.center.x -= self.superview?.frame.width ?? 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.x = currentCenter.x
               self.alpha = 0
           }, completion: nil)
       }
    
       func fadeOutRight(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.center.x += 35
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.x = currentCenter.x
               self.alpha = 0
           }, completion: nil)
       }
    
       func fadeOutRightBig(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.center.x += self.superview?.frame.width ?? 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.x = currentCenter.x
               self.alpha = 0
           }, completion: nil)
       }
    
       func fadeOutUp(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.center.y += 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.y = currentCenter.y
               self.alpha = 0
           }, completion: nil)
       }
    
       func fadeOutUpBig(duration: Double = 1.5, delay: Double = 0){
           let currentCenter = self.center
           self.center.y += self.superview?.frame.height ?? 30
           UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: [], animations: {
               self.center.y = currentCenter.y
               self.alpha = 0
           }, completion: nil)
       }
       //Flipping aimations
       
       func flipLeft(duration: Double = 1.5){
           UIView.transition(with: self, duration: duration, options: [.transitionFlipFromLeft], animations: {
               
           }, completion: nil)
       }
    
       func flipInRight(duration: Double = 1.5){
           UIView.transition(with: self, duration: duration, options: [.transitionFlipFromRight], animations: {
               
           }, completion: nil)
       }
    
       func flipInDown(duration: Double = 1.5){
           UIView.transition(with: self, duration: duration, options: [.transitionFlipFromBottom], animations: {
               
           }, completion: nil)
       }
    
       func flipInUp(duration: Double = 1.5){
           UIView.transition(with: self, duration: duration, options: [.transitionFlipFromTop], animations: {
               
           }, completion: nil)
       }
}


