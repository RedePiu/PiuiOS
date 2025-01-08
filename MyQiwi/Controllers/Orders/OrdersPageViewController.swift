//
//  OrdersPageViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class OrdersPageViewController : UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: - Properties
    var orderedViewControllers = [UIViewController]()
    lazy var ordersProRN = OrdersProRN(delegate: self)
    private lazy var firstViewController = self.viewControllers?.first
    
    // MARK: - View Lifecycle
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scSegment.tintColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scSegment.tintColorDidChange()
        self.scSegment.tintColor = UIColor.white
        
        setNeedsStatusBarAppearanceUpdate()
        self.view.layer.backgroundColor = UIColor.white.cgColor
        
        scSegment.isHidden = !UserRN.hasLoggedUser()
        
        if ApplicationRN.isQiwiPro() {
            self.scSegment.removeSegment(at: 0, animated: false)
            self.scSegment.removeSegment(at: 1, animated: false)
            
            self.scSegment.insertSegment(withTitle: "Pré Pago", at: 0, animated: false)
            self.scSegment.insertSegment(withTitle: "Pós Pago", at: 1, animated: false)
            self.scSegment.insertSegment(withTitle: "Todos", at: 2, animated: false)
            
            self.scSegment.removeSegment(at: 3, animated: false)
            
            Util.showLoading(self)
            self.ordersProRN.getOrders(daysBack: 1, type: ActionFinder.OrderPro.TYPE_ALL)
            return
        }
        
        //Se for qiwi brasil
        self.setupQiwiBrasil()
    }
    
    @IBOutlet weak var scSegment: UISegmentedControl!
    
    @IBAction func scSegmentTapped(_ sender: UISegmentedControl) {
        
        let getIndex = scSegment.selectedSegmentIndex
        
        switch (getIndex) {
        case 0:
            setViewControllers(
                [self.orderedViewControllers[0]],
                direction: .reverse,
                animated: true,
                completion: nil
            )
            
        case 1:
            setViewControllers(
                [self.orderedViewControllers[1]],
                direction: .forward,
                animated: true,
                completion: nil
            )
            
        case 2:
            setViewControllers(
                [self.orderedViewControllers[2]],
                direction: .forward,
                animated: true,
                completion: nil
            )
        default:
            break
        }
    }
    
    var currentIndex:Int {
        get {
            return orderedViewControllers.index(of: self.firstViewController ?? UIViewController()) ?? 0
        } set {
            guard newValue >= 0,
                  newValue < orderedViewControllers.count else { return }
            
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
                            transitionCompleted completed: Bool
    ) {
        scSegment.selectedSegmentIndex = currentIndex
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}

extension OrdersPageViewController {
    func startSegment() {
        if let firstViewController = orderedViewControllers.first {
            setViewControllers(
                [firstViewController],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
        
        self.scSegment.selectedSegmentIndex = 0
        self.dataSource = self
        self.delegate = self
    }
    
    func setupQiwiBrasil() {
        self.orderedViewControllers.append(self.newVc(viewController: "sbOrders"))
        self.orderedViewControllers.append(self.newVc(viewController: "sbReceipts"))
        
        self.startSegment()
    }
    
    func setupQiwiPro(object: AnyObject?) {
        guard let orders = object as? [OrderProContainer] else { return }
        
        self.orderedViewControllers.append(self.newVc(viewController: "sbOrdersPro"))
        self.orderedViewControllers.append(self.newVc(viewController: "sbOrdersPro"))
        self.orderedViewControllers.append(self.newVc(viewController: "sbOrdersPro"))
        
        let preVC = self.orderedViewControllers[0] as! OrdersProViewController
        let posVC = self.orderedViewControllers[1] as! OrdersProViewController
        let allVC = self.orderedViewControllers[2] as! OrdersProViewController
        
        preVC.ordersType = ActionFinder.OrderPro.TYPE_PRE_PAGO
        preVC.ordersContainers = self.ordersProRN.splitOrders(orderContainers: orders, type: ActionFinder.OrderPro.TYPE_PRE_PAGO)
        posVC.ordersType = ActionFinder.OrderPro.TYPE_POS_PAGO
        posVC.ordersContainers = self.ordersProRN.splitOrders(orderContainers: orders, type: ActionFinder.OrderPro.TYPE_POS_PAGO)
        allVC.ordersType = ActionFinder.OrderPro.TYPE_ALL
        allVC.ordersContainers = self.ordersProRN.splitOrders(orderContainers: orders, type: ActionFinder.OrderPro.TYPE_ALL)
        
        self.startSegment()
    }
}

extension OrdersPageViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if param == Param.Contact.ORDER_PRO_LIST_RESPONSE {
                self.dismiss(animated: true, completion: nil)
                self.setupQiwiPro(object: object)
            }
        }
    }
}

// MARK: SetupUI
extension OrdersPageViewController {
    func setupUI() { }
    func setupTexts() { }
}
