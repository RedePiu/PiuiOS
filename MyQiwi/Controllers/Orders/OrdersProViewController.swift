//
//  OrdersProViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit
import BetterSegmentedControl

class OrdersProViewController: UIBaseViewController {

    // MARK: Ciclo de vida
    @IBOutlet weak var lbFilterTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewNoContent: UIView!
    @IBOutlet weak var lbNoContent: UILabel!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ordersType = ActionFinder.OrderPro.TYPE_PRE_PAGO
    var filters = OrdersProFilters()
    var ordersContainers = [OrderProContainer]()
    lazy var ordersProRN = OrdersProRN(delegate: self)
    var firstUpdated = false
    var needUpdate = true
    var isRequestingService = false
    var selectedOrder = OrderPro()

    enum CardState {
        case expanded
        case collapsed
    }

    var popoverViewController: PopoverProViewController!
    var visualEffectView: UIVisualEffectView!

    let cardHeight = CGFloat(600)
    let cardHandleAreaHeight = CGFloat(70)

    var isVisible = false
    var nextState: CardState {
        return isVisible ? .collapsed : .expanded
    }

    var runningAnimation = [UIViewPropertyAnimator]()
    var animationProgresseWhenInterrupted: CGFloat = 0

    var initialVC = OrdersPageViewController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func setupViewDidLoad() {

        if ApplicationRN.isQiwiBrasil() {
            return
        }
        
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        self.setNeedsStatusBarAppearanceUpdate()
        
        // Delegate, para ativar o refresh da lista
        self.scrollView.delegate = self

        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: Constants.Colors.Hex.colorQiwiBlue)
        self.navigationController?.navigationBar.isTranslucent = false
        setNeedsStatusBarAppearanceUpdate()

        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)


        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear

        self.viewLoading.isHidden = true
        self.setupCard()
    }

    func setupCard() {

        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        //  self.view.addSubview(visualEffectView)

        popoverViewController = PopoverProViewController(nibName: "PopoverPro", bundle: nil)
        self.addChildViewController(popoverViewController)
        self.view.addSubview(popoverViewController.view)

        popoverViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - 240, width: self.view.bounds.width, height: cardHeight)

        popoverViewController.view.clipsToBounds = true
        popoverViewController.view.layer.cornerRadius = 8

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))

        popoverViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        popoverViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {

        switch recognizer.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.4)
        default:
            break
        }
    }

    override func setupViewWillAppear() {

        if UserRN.hasLoggedUser() {
            
            Util.removeNeedLogin(self)
            
            if !self.firstUpdated {
                self.firstUpdated = true

                self.updateList(orders: self.ordersContainers)
            }
        } else {
            // Mostra login
            Util.showNeedLogin(self)
        }
    }

    func setupHeightTable() {

        self.height.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            //self.layoutIfNeeded()
        }
    }

    func setupNib() {
        self.tableView.register(OrderProContainerItemCell.nib(), forCellReuseIdentifier: "Cell")
    }

}

// MARK: Delegate ScrollView
extension OrdersProViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !self.isRequestingService {
            // Sendo negativo o contentOffset.y, acionar o refresh da lista
            if scrollView.contentOffset.y < -40 {
                
                // Anima views
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
                
                //Faz o request
                self.requestOrders()
            }
        }
    }
}

// MARK: Segue Idetifier
extension OrdersProViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ORDER_DETAIL {
            if let vc = segue.destination as? OrderDetailViewController {
                
                self.needUpdate = false
                
                // Passa item
                vc.orderId = self.selectedOrder.orderId
                vc.transitionId = self.selectedOrder.transactionId
                vc.canShowReceipt = self.selectedOrder.canShow
            }
        }
    }
}

// MARK: Observer Height Collection
extension OrdersProViewController {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.height.constant = size.height
                    return
                }
            }
        }

        self.height.constant = self.tableView.contentSize.height - 40
    }

    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startTransition(state: nextState, duration: 0.4)
        case .changed:
            let translation = recognizer.location(in: self.popoverViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = isVisible ? fractionComplete : -fractionComplete
            updateTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueTransition()
        default:
            break
        }
    }

    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimation.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.popoverViewController.view.frame.origin.y = self.view.frame.height - (self.cardHeight - 170)
                case .collapsed:
                    self.popoverViewController.view.frame.origin.y = self.view.frame.height - (self.cardHandleAreaHeight)
                }
            }

            frameAnimator.addCompletion { _ in
                self.isVisible = !self.isVisible
                self.runningAnimation.removeAll()
            }

            frameAnimator.startAnimation()
            runningAnimation.append(frameAnimator)

            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {

                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
//                    self.popoverViewController.imgArrow.image = UIImage(named: "ic_arrow_down")
                    self.popoverViewController.imgArrow.image = #imageLiteral(resourceName: "ic_arrow_down").withRenderingMode(.alwaysTemplate)
                    self.popoverViewController.imgArrow.tintColor = Theme.default.white
                case .collapsed:
                    self.visualEffectView.effect = nil
//                    self.popoverViewController.imgArrow.image = UIImage(named: "ic_arrow_up")
                    self.popoverViewController.imgArrow.image = #imageLiteral(resourceName: "ic_arrow_up").withRenderingMode(.alwaysTemplate)
                    self.popoverViewController.imgArrow.tintColor = Theme.default.white
                }
            }

            blurAnimator.startAnimation()
            runningAnimation.append(blurAnimator)
        }
    }

    func startTransition(state: CardState, duration: TimeInterval) {

        if runningAnimation.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }

        for animator in runningAnimation {
            animator.pauseAnimation()
            animationProgresseWhenInterrupted = animator.fractionComplete
        }
    }

    func updateTransition(fractionCompleted: CGFloat) {

        for animator in runningAnimation {
            animator.fractionComplete = fractionCompleted + animationProgresseWhenInterrupted
        }
    }

    func continueTransition() {

        for animator in runningAnimation {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}

extension OrdersProViewController {

    @IBAction func displayFiltersSheet (_ sender: Any) {

        // 1
        let optionMenu = UIAlertController(title: nil, message: "qiwi_statement_choose_an_option".localized, preferredStyle: .actionSheet)

        // 2
        let lastDay = UIAlertAction(title: "qiwi_statement_last_day".localized, style: .default, handler: { action in
            self.filters.filter = .LAST_DAY
            self.updateFilter()
        })
        // 2
        let last7Days = UIAlertAction(title: "qiwi_statement_last_7_days".localized, style: .default, handler: { action in
            self.filters.filter = .LAST_7_DAYS
            self.updateFilter()
        })
        // 2
        let last15Days = UIAlertAction(title: "qiwi_statement_last_15_days".localized, style: .default, handler: { action in
            self.filters.filter = .LAST_15_DAYS
            self.updateFilter()
        })
        let last30Days = UIAlertAction(title: "qiwi_statement_last_30_days".localized, style: .default, handler: { action in
            self.filters.filter = .LAST_30_DAYS
            self.updateFilter()
        })
        let selectDay = UIAlertAction(title: "qiwi_statement_select_a_day".localized, style: .default, handler: { action in

            DispatchQueue.main.async {
                Util.showController(DatePickerCompleteViewController.self, sender: self, completion: { controller in
                    controller.delegate = self
                    controller.currentDay = self.filters.day
                    controller.currentMonth = self.filters.month
                    controller.currentYear = self.filters.year
                })
            }
        })
        let selectMonth = UIAlertAction(title: "qiwi_statement_select_a_month".localized, style: .default, handler: { action in

            DispatchQueue.main.async {
                Util.showController(DatePickerViewController.self, sender: self, completion: { controller in
                    controller.delegate = self
                    controller.currentMonth = self.filters.month
                    controller.currentYear = self.filters.year
                })
            }
        })

        // 3
        let cancelAction = UIAlertAction(title: "qiwi_statement_cancel".localized, style: .cancel)

        // 4
        optionMenu.addAction(lastDay)
        optionMenu.addAction(last7Days)
        optionMenu.addAction(last15Days)
        optionMenu.addAction(last30Days)
        optionMenu.addAction(selectDay)
        optionMenu.addAction(selectMonth)
        optionMenu.addAction(cancelAction)

        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }

    func updateFilter() {
        self.lbFilterTitle.text = self.filters.getFilterName()

        self.requestOrders()
    }

    func requestOrders() {
        self.isRequestingService = true
        self.viewLoading.isHidden = false

        if self.filters.filter == .MONTH {
            self.ordersProRN.getOrders(month: self.filters.month, year: self.filters.year, type: self.ordersType)
        }
        
        if self.filters.filter == .DAY {
            self.ordersProRN.getOrders(date: self.filters.date, type: self.ordersType)
        }

        else if self.filters.filter == .LAST_DAY {
            self.ordersProRN.getOrders(daysBack: 1, type: self.ordersType)
        }

        else if self.filters.filter == .LAST_7_DAYS {
            self.ordersProRN.getOrders(daysBack: 7, type: self.ordersType)
        }

        else if self.filters.filter == .LAST_15_DAYS {
            self.ordersProRN.getOrders(daysBack: 15, type: self.ordersType)
        }

        else if self.filters.filter == .LAST_30_DAYS {
            self.ordersProRN.getOrders(daysBack: 30, type: self.ordersType)
        }
    }

    func updateList(orders: [OrderProContainer]) {
        self.ordersContainers = orders

        DispatchQueue.main.async {
            self.popoverViewController.countList = self.ordersProRN.somarValores(containers: self.ordersContainers)
            self.popoverViewController.tableView.reloadData()

            self.popoverViewController.lbTotalPrice.text = Util.formatCoin(value: self.ordersProRN.calculateTotalPrice(proValues: self.popoverViewController.countList))
            self.popoverViewController.lbTotalCommission.text = Util.formatCoin(value: self.ordersProRN.calculateTotalCommission(proValues: self.popoverViewController.countList))
        }

        if orders.isEmpty {
            self.lbNoContent.text = "order_pro_no_content".localized
            self.viewNoContent.isHidden = false
            self.tableView.isHidden = true
            return
        }

        self.viewNoContent.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
}

// MARK: TableView
extension OrdersProViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            
            if fromClass == DatePickerViewController.self {
                if param == Param.Contact.DATAPICKER_RESPONSE {
                    let monthAndYear = object as! String
                    self.filters.setDate(monthAndYear: monthAndYear)
                    self.filters.filter = .MONTH
                    self.updateFilter()
                }
            }
            
            if fromClass == DatePickerCompleteViewController.self {
                if param == Param.Contact.DATAPICKER_RESPONSE {
                    let date = object as! Date
                    
                    self.filters.SetCompleteDate(date: date)
                    self.filters.filter = .DAY
                    self.updateFilter()
                }
            }
            
            if fromClass == OrderProContainerItemCell.self {
                if param == Param.Contact.LIST_CLICK {
                    self.selectedOrder = object as! OrderPro
                    self.performSegue(withIdentifier: Constants.Segues.ORDER_DETAIL, sender: nil)
                }
            }

            if fromClass == OrdersProRN.self {
                if param == Param.Contact.ORDER_PRO_LIST_RESPONSE {
                    self.isRequestingService = false
                    self.viewLoading.isHidden = true

                    if !result {
                        self.lbNoContent.text = "order_pro_no_content".localized
                        self.viewNoContent.isHidden = false
                        self.tableView.isHidden = true
                        return
                    }

                    self.updateList(orders: object as! [OrderProContainer])
                }
            }
        }
    }
}

extension OrdersProViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ordersContainers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderProContainerItemCell
        //
        let index = indexPath.row
        let item = self.ordersContainers[index]
        cell.item = item
        cell.delegate = self
        cell.isAll = self.ordersType == ActionFinder.OrderPro.TYPE_ALL

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 222
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension OrdersProViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //        self.isEditingTableView = true
        //
        //        self.resetNavigation()
        //        self.setItensNavigation(indexPath: indexPath)
    }
}

// MARK: SetupUI
extension OrdersProViewController: SetupUI {

    func setupLayout() {

    }

    func setupUI() {
        Theme.default.backgroundCard(self)

        self.lbNoContent.setupMessageMedium()
        self.lbFilterTitle.setupMessageMedium()
    }

    func setupTexts() {
        self.lbFilterTitle.text = "qiwi_statement_last_day".localized
    }
}
