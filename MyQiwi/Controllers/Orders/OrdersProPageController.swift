//
//  OrdersProPageController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class OrdersProPageController : UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    @IBOutlet weak var scSegment: UISegmentedControl!
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "sbOdersPro"),
        self.newVc(viewController: "sbOdersPro"),
        self.newVc(viewController: "sbOdersPro")]
    }()
    
    override func viewDidLoad() {
        self.dataSource = self
        self.delegate = self
        let navbar = UINavigationBar.appearance()
        navbar.barTintColor = .white
        navbar.tintColor = .white
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        scSegment.isHidden = !UserRN.hasLoggedUser()
    }
    
    @IBAction func scSegmentTapped(_ sender: UISegmentedControl) {
        
        let getIndex = scSegment.selectedSegmentIndex
        
        switch (getIndex) {
        case 0:
            setViewControllers([self.orderedViewControllers[0]],
                               direction: .reverse,
                               animated: true,
                               completion: nil)
        case 1:
        setViewControllers([self.orderedViewControllers[1]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        case 2:
        setViewControllers([self.orderedViewControllers[2]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        default:
            break
        }
        
    }
    
    var currentIndex:Int {
        get {
            return orderedViewControllers.index(of: self.viewControllers!.first!)!
        }
        
        set {
            guard newValue >= 0,
                newValue < orderedViewControllers.count else {
                    return
            }
            
            let vc = orderedViewControllers[newValue]
            let direction:UIPageViewControllerNavigationDirection = newValue > currentIndex ? .forward : .reverse
            self.setViewControllers([vc], direction: direction, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            //return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            //return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                                     didFinishAnimating finished: Bool,
                                     previousViewControllers: [UIViewController],
                                     transitionCompleted completed: Bool) {
        scSegment.selectedSegmentIndex = currentIndex
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return currentIndex
    }
}

// MARK: SetupUI

extension OrdersProPageController {
    
    func setupUI() {
        
    }
    
    func setupTexts() {

    }
}

