//
//  OrdersNewPageViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 09/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import EVTopTabBar
import UIKit

class OrdersNewPageViewController : UIViewController, EVTabBar {
    
    var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var topTabBar: EVPageViewTopTabBar? {
        didSet {
            topTabBar?.fontColors = (selectedColor: UIColor.gray, unselectedColor: UIColor.lightGray)
            topTabBar?.rightButtonText = "Events"
            topTabBar?.leftButtonText = "Contacts"
            topTabBar?.middleButtonText = "Tasks"
            topTabBar?.middleRightButtonText = "Locations"
            topTabBar?.labelFont = UIFont(name: "Helvetica", size: 11)!
            topTabBar?.indicatorViewColor = UIColor.blue
            topTabBar?.backgroundColor = UIColor.white
            topTabBar?.delegate = self
        }
    }
    var subviewControllers: [UIViewController] = []
    var shadowView = UIImageView(image: UIImage(named: ""))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTabBar = EVPageViewTopTabBar(for: .four)
        let firstVC = OrdersViewController(nibName:"sbOrders", bundle: nil)
        let secondVC = ReceiptViewController(nibName:"sbReceipts", bundle: nil)
        subviewControllers = [firstVC, secondVC]
        setupPageView()
        setupConstraints()
        self.title = "Pedidos"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: EVTabBarDataSource
extension OrdersNewPageViewController: EVTabBarDelegate {
    func willSelectViewControllerAtIndex(_ index: Int, direction: UIPageViewControllerNavigationDirection) {
        if index > subviewControllers.count {
            pageController.setViewControllers([subviewControllers[subviewControllers.count - 1]], direction: direction, animated: true, completion: nil)
        } else {
            pageController.setViewControllers([subviewControllers[index]], direction: direction, animated: true, completion: nil)
        }
    }
}
