//
//  UrbsDetailsViewController.swift
//  MyQiwi
//
//  Created by Thyago on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class UrbsStatementViewController: UIBaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var imgEmpty: UIImageView!
    @IBOutlet weak var lbFilterName: UILabel!
    @IBOutlet weak var lbEmpty: UILabel!
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var lbNoContent: UILabel!
    
    var needReload = true
    lazy var transportUrbsRN = TransportCardUrbsRN(delegate: self)
    var qiwiStatementFilters = QiwiStatementFilters()
    var registries = [UrbsRegistry]()
    var transportCard = TransportCard()
    let height = CGFloat(90)
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        
        self.scrollView.delegate = self
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = height
        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func setupViewWillAppear() {
        Util.setLogoBarIn(self)
        //self.tabBarController?.delegate = self
        
        if UserRN.hasLoggedUser() {
            // Logado
            Util.removeNeedLogin(self)
        } else {
            Util.showNeedLogin(self)
            return
        }
        
        if self.needReload {
            self.updateFilter()
        }
        self.needReload = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.contentSize.height = height
    }
}

extension UrbsStatementViewController {
    
    func requestStatements() {
        
        self.showLoading()
        
        if self.qiwiStatementFilters.filter == .MONTH {
            
            self.transportUrbsRN.consultCardStatement(cardNumber: self.transportCard.number, month: self.qiwiStatementFilters.month, year: self.qiwiStatementFilters.year)
        }
        else if self.qiwiStatementFilters.filter == .LAST_15_DAYS {
            self.transportUrbsRN.consultCardStatement(cardNumber: self.transportCard.number, daysBack: 15)
        }
        else if self.qiwiStatementFilters.filter == .LAST_30_DAYS {
            self.transportUrbsRN.consultCardStatement(cardNumber: self.transportCard.number, daysBack: 30)
        }
    }
}

extension UrbsStatementViewController {
    
    func setupNib() {
        self.tableView.register(UrbsStatementItemCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    func setupHeightTable() {
        
        self.heightTable.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showLoading() {
        self.viewLoading.isHidden = false
        self.tableView.isHidden = true
        self.viewEmpty.isHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightTable.constant = size.height
                    return
                }
            }
        }
        
        self.heightTable.constant = self.tableView.contentSize.height
        
        self.setupHeightTable()
    }
}

extension UrbsStatementViewController {
    
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

extension UrbsStatementViewController: BaseDelegate {
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
            
            if fromClass == TransportCardUrbsRN.self {
                if param == Param.Contact.TRANSPORT_CARD_URBS_STATEMENT_CONSULT_RESPONSE {
                    self.viewLoading.isHidden = true
                    
                    if result {
                        self.registries = object as! [UrbsRegistry]
                        self.tableView.reloadData()
                        
                        if !self.registries.isEmpty {
                            self.tableView.isHidden = false
                            self.viewEmpty.isHidden = true
                            return
                        }
                    }
                    
                    self.lbNoContent.text = result ? "transport_urbs_statement_no_content".localized : "transport_urbs_statement_no_content_error".localized
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

extension UrbsStatementViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.registries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UrbsStatementItemCell
        //
        let index = indexPath.row
        let item = self.registries[index]
        cell.item = item
        
        self.setupHeightTable()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension UrbsStatementViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        self.isEditingTableView = true
        //
        //        self.resetNavigation()
        //        self.setItensNavigation(indexPath: indexPath)
    }
}

extension UrbsStatementViewController: SetupUI {
    
    func setupUI() {
        Theme.default.backgroundCard(self)
        self.lbFilterName.setupMessageMedium()
        self.tableView.backgroundColor = .clear
    }
    
    func setupTexts() {
        Util.setTextBarIn(self, title: "".localized)
    }
}
