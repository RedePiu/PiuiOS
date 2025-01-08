//
//  AcountViewController.swift
//  MyQiwi
//
//  Created by Douglas on 04/05/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class AcountViewController: UIBaseViewController {

    // MARK: Outlets
    
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var viewBalance: ViewBalance!
    @IBOutlet weak var viewBalancePrePago: ViewBalancePrePago!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var btnTransfer: UIButton!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnChangeFilters: UIButton!
    @IBOutlet weak var lbFilterName: UILabel!
    
    // MARK: Ciclo de vida
    var needReload = true
    var statements: [Statement] = []
    lazy var mStatementRN = StatementRN(delegate: self)
    var selectedStatement = StatementTransactions()
    var qiwiStatementFilters = QiwiStatementFilters()
    var transitionDate: String = ""
    var isPrePago = false
    var isRequestingService = false
    
    @IBOutlet weak var viewTypeCreditSelection: UIView!
    @IBOutlet weak var viewPrePago: UIView!
    @IBOutlet weak var viewContaQiwi: UIView!
    @IBOutlet weak var imgPrePago: UIImageView!
    @IBOutlet weak var lbPrePago: UILabel!
    @IBOutlet weak var imgContaQiwi: UIImageView!
    @IBOutlet weak var lbContaQiwi: UILabel!
    var refreshControl = UIRefreshControl()
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        self.viewBalance.delegate = self
        self.viewBalancePrePago.delegate = self
        
        // Delegate, para ativar o refresh da lista
        self.scrollView.delegate = self
        self.viewBalance.btnRecharge.addTarget(self, action: #selector(onClickRecharge), for: .touchUpInside)
        self.viewBalance.btnHistorico.addTarget(self, action: #selector(onClickHistorico), for: .touchUpInside)
        self.viewBalance.btnTransfer.addTarget(self, action: #selector(onClickTransfer), for: .touchUpInside)
        
        self.viewBalancePrePago.btnRecharge.addTarget(self, action: #selector(onClickQiwiTransferForPrePago), for: .touchUpInside)
        
        if ApplicationRN.isQiwiPro() {
        
            self.viewTypeCreditSelection.isHidden = false
            self.isPrePago = true
            
            let clickContaQiwi = UITapGestureRecognizer(target: self, action:  #selector (self.selectContaQiwi))
            let clickPrePago = UITapGestureRecognizer(target: self, action:  #selector (self.selectPrePago))
            self.viewContaQiwi.addGestureRecognizer(clickContaQiwi)
            self.viewPrePago.addGestureRecognizer(clickPrePago)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Puxe para atualizar")
        refreshControl.addTarget(self, action: #selector(onSwipeRefresh), for: UIControl.Event.valueChanged)
        scrollView.refreshControl = refreshControl
        
        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func setupViewWillAppear() {
        Util.setLogoBarIn(self)
        self.tabBarController?.delegate = self
        
        if UserRN.hasLoggedUser() {
            // Logado
            Util.removeNeedLogin(self)
        } else {
            Util.showNeedLogin(self)
            return
        }
        
        self.updateAllServices()
    }
    
    func setupHeightTable() {
        
        self.height.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            //self.layoutIfNeeded()
        }
    }
    
    func setupNib() {
        self.tableView.register(StatementCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    func updateAllServices() {
        if self.needReload {
            if ApplicationRN.isQiwiPro() {
                self.viewBalancePrePago.updateBalance()
            } else {
                self.viewBalance.updateBalance()
            }
        }
        self.needReload = true
    }
}

extension AcountViewController {
 
    @objc func selectContaQiwi() {
        self.viewPrePago.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorGrey3)
        self.viewContaQiwi.backgroundColor = .white
        
        self.isPrePago = false
        self.requestStatements()
        
        self.viewBalance.isHidden = false
        self.viewBalancePrePago.isHidden = true
    }
    
    @objc func selectPrePago() {
        self.viewContaQiwi.backgroundColor = UIColor(hexString: Constants.Colors.Hex.colorGrey3)
        self.viewPrePago.backgroundColor = .white
        
        self.isPrePago = true
        self.requestStatements()
        
        self.viewBalance.isHidden = true
        self.viewBalancePrePago.isHidden = false
    }
}

// MARK: Delegate TabBar
extension AcountViewController {
    
    @objc func onSwipeRefresh() {
        self.refreshControl.endRefreshing()
        
        if ApplicationRN.isQiwiPro() {
            self.viewBalancePrePago.updateBalance()
        } else {
            self.viewBalance.updateBalance()
        }
    }
    
    @objc func onClickRecharge() {
        
        if !UserRN.getLoggedUser().isQiwiAccountactive {
            self.performSegue(withIdentifier: Constants.Segues.CREATE_QIWI_PASS, sender: nil)
            return
        }
        
        QiwiOrder.startQiwiChargeOrder()
        QiwiOrder.delegate = self
        ListGenericViewController.stepListGeneric = .SELECT_VALUE
        performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    @objc func onClickQiwiTransferForPrePago() {

        QiwiOrder.startQiwiTransferForPrePago()
        QiwiOrder.delegate = self
        ListGenericViewController.stepListGeneric = .SELECT_VALUE
        performSegue(withIdentifier: Constants.Segues.LIST_GENERIC, sender: nil)
    }
    
    @objc func onClickTransfer() {
        if (ApplicationRN.isQiwiBrasil()) {
            performSegue(withIdentifier: Constants.Segues.CREDIT_TRANSFER, sender: nil)
        } else {
            performSegue(withIdentifier: Constants.Segues.HISTORICO_COMPRAS, sender: nil)
        }
    }
    
    @objc func onClickHistorico() {
        performSegue(withIdentifier: Constants.Segues.HISTORICO_COMPRAS, sender: nil)
    }
}

// MARK: Observer Height Collection
extension AcountViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.height.constant = size.height
                    return
                }
            }
        }
        
        self.height.constant = self.tableView.contentSize.height
    }
}

// MARK: Delegate ScrollView
extension AcountViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Caso nao esteja fazem um request no momento
        if !self.isRequestingService {
            
            let contentYoffset = scrollView.contentOffset.y

            // Sendo negativo o contentOffset.y, acionar o refresh da lista
            if scrollView.contentOffset.y < -40 {
                
//                // Ativar loading
//                self.viewLoading.isHidden = false
//
//                // Anima views
//                UIView.animate(withDuration: 0.2) {
//                    self.view.layoutIfNeeded()
//                }
//
//                self.requestStatements()
            }
        }
    }
}

// MARK: Delegate TabBar
extension AcountViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UserRN.hasLoggedUser() {
            Util.removeNeedLogin(self)
        } else {
            Util.showController(WarningViewController.self, sender: self, completion: { controller in controller.getLogoutIntent() })
            UserRN.clearLoggedUser()
        }
    }
}

// MARK: IBActions
extension AcountViewController {
    
    
    @IBAction func addCard(sender: UIButton) {
        
        // Não logado
        if !UserRN.hasLoggedUser() {
            Util.showNeedLogin(self)
            return
        }
    }
    
    @IBAction func startOrderDetails() {
        
//        let navigation = UIStoryboard(name: "OrderDetails", bundle: .main).instantiateViewController(withIdentifier: "OrderDetails")
//
//        if let ordersVC = navigation as? OrderDetailViewController {
//            self.needReload = false
//            ordersVC.orderId = id
//            self.navigationController?.pushViewController(navigation, animated: true)
//        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if !UserRN.hasLoggedUser(){
            
            UserRN.clearLoggedUser()
            Util.showNeedLogin(self)
            
        } else {
            if segue.identifier == Constants.Segues.ORDER_DETAIL {
                if let vc = segue.destination as? OrderDetailViewController {
                    if !UserRN.hasLoggedUser() {
                        Util.showController(WarningViewController.self, sender: self, completion: { controller in controller.getLogoutIntent() })
                        Util.showNeedLogin(self)
                    } else {
                        self.needReload = false
                        // Passa item
                        vc.orderId = self.selectedStatement.orderId
                        vc.transitionId = self.selectedStatement.transactionId
                        vc.canShowReceipt = self.selectedStatement.canShowReceipt
                        vc.transitionDate = self.transitionDate
                    }
                }
            }
        }
        return
    }

    func requestStatements() {
        self.viewLoading.isHidden = false
        self.tableView.isHidden = true
        self.viewEmpty.isHidden = true
        
        self.isRequestingService = true
        
        if self.qiwiStatementFilters.filter == .MONTH {
            self.mStatementRN.getStatementList(month: self.qiwiStatementFilters.month, year: self.qiwiStatementFilters.year, isPrePago: self.isPrePago)
        }
        
        else if self.qiwiStatementFilters.filter == .LAST_15_DAYS {
            self.mStatementRN.getStatementList(daysBack: 15, isPrePago: self.isPrePago)
        }
        
        else if self.qiwiStatementFilters.filter == .LAST_30_DAYS {
            self.mStatementRN.getStatementList(daysBack: 30, isPrePago: self.isPrePago)
        }
    }
}

// MARK: IBActions
extension AcountViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            
            if fromClass == QiwiOrder.self {
                if param == Param.Contact.NEED_UPDATE_DATA {
                    self.updateAllServices()
                }
            }
            
            if fromClass == DatePickerViewController.self {
                if param == Param.Contact.DATAPICKER_RESPONSE {
                    let monthAndYear = object as! String
                    self.qiwiStatementFilters.setDate(monthAndYear: monthAndYear)
                    self.qiwiStatementFilters.filter = .MONTH
                    self.updateFilter()
                }
            }
            
            if fromClass == StatementCell.self {
                if param == Param.Contact.LIST_CLICK {
                    
                    let objs = object as! [AnyObject]
                    
                    self.selectedStatement = objs[0] as! StatementTransactions
                    self.transitionDate = objs[1] as! String
                    self.needReload = false
                    
                    self.performSegue(withIdentifier: Constants.Segues.ORDER_DETAIL, sender: nil)
                    return
                }
            }
            
            if fromClass == ViewBalancePrePago.self {
                if param == Param.Contact.PRE_PAGO_BALANCE_RESPONSE {
                    self.viewBalance.updateBalance()
                }
            }
            
            if fromClass == ViewBalance.self {
                if param == Param.Contact.QIWI_BALANCE_RESPONSE {
                    
                    if ApplicationRN.isQiwiPro() {
                        if !self.isPrePago {
                            self.selectContaQiwi()
                        } else {
                            
                            self.selectPrePago()
                        }
                        
                    } else {
                        self.requestStatements()
                    }
                }
                return
            }
            
            if fromClass == StatementRN.self {
                if param == Param.Contact.QIWI_STATEMENT_RESPONSE {
                    self.viewLoading.isHidden = true
                    self.isRequestingService = false
                    
                    if result {
                        self.statements = object as! [Statement]
                        self.tableView.reloadData()
                        
                        if !self.statements.isEmpty {
                            self.tableView.isHidden = false
                            self.viewEmpty.isHidden = true
                            return
                        }
                    }
                    
                    self.tableView.isHidden = true
                    self.viewEmpty.isHidden = false
                    
                    UIView.animate(withDuration: 0.2) {
                        self.view.layoutIfNeeded()
                    }
                }
                return
            }
        }
    }
}

// MARK: SetupUI
extension AcountViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        self.lblEmpty.setupMessageMedium()
        self.lbFilterName.setupMessageMedium()
        
        let colorText = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
        
        self.imgContaQiwi.image = UIImage(named: "qiwi_logo")?.withRenderingMode(.alwaysTemplate)
        self.imgContaQiwi.tintColor = colorText
        
        self.imgPrePago.image = UIImage(named: "ic_transport_comum")?.withRenderingMode(.alwaysTemplate)
        self.imgPrePago.tintColor = colorText
        
        self.lbContaQiwi.textColor = colorText
        self.lbPrePago.textColor = colorText
        
        //Theme.default.blueButton(self.btnTransfer)
    }
    
    func setupTexts() {
        self.lblEmpty.text = "statement_no_content".localized
    }
}

extension AcountViewController {
    
    @IBAction func displayFiltersSheet (_ sender: Any) {
        
        // 1
        let optionMenu = UIAlertController(title: nil, message: "qiwi_statement_choose_an_option".localized, preferredStyle: .actionSheet)
        
        // 2
        let last15Days = UIAlertAction(title: "qiwi_statement_last_15_days".localized, style: .default, handler: { action in
            self.qiwiStatementFilters.filter = .LAST_15_DAYS
            self.updateFilter()
        })
        let last30Days = UIAlertAction(title: "qiwi_statement_last_30_days".localized, style: .default, handler: { action in
            self.qiwiStatementFilters.filter = .LAST_30_DAYS
            self.updateFilter()
        })
        let selectMonth = UIAlertAction(title: "qiwi_statement_select_a_month".localized, style: .default, handler: { action in
            
            DispatchQueue.main.async {
                Util.showController(DatePickerViewController.self, sender: self, completion: { controller in
                    controller.delegate = self
                    controller.currentMonth = self.qiwiStatementFilters.month
                    controller.currentYear = self.qiwiStatementFilters.year
                })
            }
        })
        
        // 3
        let cancelAction = UIAlertAction(title: "qiwi_statement_cancel".localized, style: .cancel)
        
        // 4
        optionMenu.addAction(last15Days)
        optionMenu.addAction(last30Days)
        optionMenu.addAction(selectMonth)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func updateFilter() {
        self.lbFilterName.text = self.qiwiStatementFilters.getFilterName()
        
        self.requestStatements()
    }
}

extension AcountViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StatementCell
        //
        let index = indexPath.row
        let item = self.statements[index]
        cell.item = item
        cell.delegate = self
        
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

extension AcountViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        self.isEditingTableView = true
        //
        //        self.resetNavigation()
        //        self.setItensNavigation(indexPath: indexPath)
    }
}

