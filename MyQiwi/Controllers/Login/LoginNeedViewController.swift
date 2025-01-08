//
//  LoginNeedViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 14/06/2018.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit
import BmoViewPager

class LoginNeedViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var btnEnter: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewPager: BmoViewPager!
    
    // MARK: Variables
    
    var timerPages: Timer!
    var viewControllers = [UIViewController]()
    
    // MARK: Ciclo de vida
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        
        self.viewPager.delegate = self
        self.viewPager.dataSource = self
        
        self.fillListViewControllers()
    }
    
    override func setupViewWillAppear() {
        
        let seconds = TimeInterval(integerLiteral: 5)
        self.timerPages = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(reloadPages), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.timerPages.isValid {
            self.timerPages.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Selector
extension LoginNeedViewController {
    
    @objc func reloadPages() {
        
        var currentPage = self.viewPager.pageControlIndex
        currentPage += 1
        
        self.viewPager.presentedPageIndex = currentPage
        
        if currentPage >= self.viewControllers.count {
            self.viewPager.pageControlIndex = 0
        }
        
        self.viewPager.reloadData()
    }
}

// MARK: Data BmoViewPager
extension LoginNeedViewController: BmoViewPagerDataSource {
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        
        return self.viewControllers.count
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        return self.viewControllers[page]
    }
}

// MARK: Delegate BmoViewPager
extension LoginNeedViewController: BmoViewPagerDelegate {
    
    func bmoViewPagerDelegate(_ viewPager: BmoViewPager, pageChanged page: Int) {
        self.pageControl.currentPage = page
    }
}

// MARK: Fill List
extension LoginNeedViewController {
    
    func fillListViewControllers() {
        
        let viewController_1 = PageViewController()
        viewController_1.index = 0
        viewController_1.textMessage = "login_intro_1".localized
        
        let viewController_2 = PageViewController()
        viewController_1.index = 1
        viewController_2.textMessage = "login_intro_2".localized
        
        let viewController_3 = PageViewController()
        viewController_1.index = 2
        viewController_3.textMessage = "login_intro_3".localized
        
        self.viewControllers.append(viewController_1)
        self.viewControllers.append(viewController_2)
        self.viewControllers.append(viewController_3)
        
        self.pageControl.numberOfPages = self.viewControllers.count
        self.pageControl.currentPage = 0
        
        self.pageControl.currentPageIndicatorTintColor = UIColor(hexString: Constants.Colors.Hex.colorPrimary)
        self.pageControl.pageIndicatorTintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey5)
        
        self.viewPager.reloadData()
    }
}

// MARK: SetupUI
extension LoginNeedViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.greenButton(self.btnEnter)
        Theme.default.orageButton(self.btnCreateAccount)
    }
    
    func setupTexts() {
        
        self.btnCreateAccount.setTitle("login_logon".localized, for: .normal)
        self.btnEnter.setTitle("login_enter_button".localized, for: .normal)
    }
}
