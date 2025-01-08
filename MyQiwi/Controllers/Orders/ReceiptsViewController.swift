//
//  ReceiptsViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ReceiptsViewController : UIBaseViewController {
    
    // VIEWS
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var lbFilterName: UILabel!
    
    // VARIABLES
    lazy var receiptRN = ReceiptRN(delegate: self)
    var receiptGroup = [ReceiptGroup]()
    var qiwiStatementFilters = QiwiStatementFilters()
    var transitionId: Int = 0
    var transitionDate: String = ""
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        
        // Delegate, para ativar o refresh da lista
        self.scrollView.delegate = self
        
        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func setupViewWillAppear() {
        Util.setLogoBarIn(self)
        
        if UserRN.hasLoggedUser() {
            
            Util.removeNeedLogin(self)
            self.requestReceipts()
        }else {
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
        self.tableView.register(ReceiptCell.nib(), forCellReuseIdentifier: "Cell")
    }
}

// MARK: Observer Height Collection
extension ReceiptsViewController {
    
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

extension ReceiptsViewController {
    
    func updateReceiptList(receiptGroup: [ReceiptGroup]) {
        self.receiptGroup = receiptGroup
        self.viewLoading.isHidden = true
        self.viewEmpty.isHidden = true
        //self.tableView.isHidden = true
        
        if receiptGroup.isEmpty {
            self.viewEmpty.isHidden = false
            self.tableView.isHidden = true
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            return
        }
        
        self.tableView.reloadData()
        self.tableView.isHidden = false
    }
    
    func requestReceipts() {
        if self.qiwiStatementFilters.filter == .MONTH {
            self.receiptRN.getReceipts(month: self.qiwiStatementFilters.month, year: self.qiwiStatementFilters.year)
        }
            
        else if self.qiwiStatementFilters.filter == .LAST_15_DAYS {
            self.receiptRN.getReceipts(daysBack: 15)
        }
            
        else if self.qiwiStatementFilters.filter == .LAST_30_DAYS {
            self.receiptRN.getReceipts(daysBack: 30)
        }
    }
    
    func updateFilter() {
        
        self.lbFilterName.text = self.qiwiStatementFilters.getFilterName()
        
        self.requestReceipts()
    }
}

extension ReceiptsViewController {
    @IBAction func displayFilterSheet(_ sender: Any) {
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
}

// MARK: Segue Idetifier
extension ReceiptsViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ORDER_DETAIL {
            if let vc = segue.destination as? OrderDetailViewController {
                
                // Passa item
                vc.orderId = 0
                vc.transitionId = self.transitionId
                vc.transitionDate = self.transitionDate
            }
        }
    }
}

extension ReceiptsViewController : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            
            if fromClass == DatePickerViewController.self {
                if param == Param.Contact.DATAPICKER_RESPONSE {
                    let monthAndYear = object as! String
                    self.qiwiStatementFilters.setDate(monthAndYear: monthAndYear)
                    self.qiwiStatementFilters.filter = .MONTH
                    self.updateFilter()
                }
            }
            
            if fromClass == ReceiptRN.self {
                if param == Param.Contact.QIWI_STATEMENT_RESPONSE {
                    var receiptGroup = [ReceiptGroup]()
                    
                    if result {
                        receiptGroup = object as! [ReceiptGroup]
                    }
                    
                    self.updateReceiptList(receiptGroup: receiptGroup)
                }
            }
            
            if fromClass == ReceiptCell.self {
                if param == Param.Contact.LIST_CLICK {
                    let objs = object as! [AnyObject]
                    
                    self.transitionId = objs[0] as! Int
                    self.transitionDate = objs[1] as! String
                    self.performSegue(withIdentifier: Constants.Segues.ORDER_DETAIL, sender: nil)
                }
            }
        }
    }
}

extension ReceiptsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receiptGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ReceiptCell
        //
        let index = indexPath.row
        let item = self.receiptGroup[index]
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

extension ReceiptsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        self.isEditingTableView = true
        //
        //        self.resetNavigation()
        //        self.setItensNavigation(indexPath: indexPath)
    }
}

extension ReceiptsViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        self.lbFilterName.setupMessageMedium()
        self.viewEmpty.isHidden = true
    }
    
    func setupTexts() {

    }
}

