//
//  DividasViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/01/20.
//  Copyright © 2020 Qiwi. All rights reserved.
//

import UIKit

class DividasViewController : UIBaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbFilterName: UILabel!
    @IBOutlet weak var viewNoContent: UIView!
    
    @IBOutlet weak var viewFiltersSelecteds: UICardView!
    @IBOutlet weak var viewFilters: UICardView!
    @IBOutlet weak var btnCloseFilters: UIButton!
    @IBOutlet weak var lbFilterPeriodoLabel: UILabel!
    @IBOutlet weak var lbFilterNameInside: UILabel!
    @IBOutlet weak var lbFilterStatusLabel: UILabel!
    
    @IBOutlet weak var btnFilterTodos: UIButton!
    @IBOutlet weak var btnFilterVencidas: UIButton!
    @IBOutlet weak var btnFilterPendentes: UIButton!
    @IBOutlet weak var btnFilterConcluidos: UIButton!
    @IBOutlet weak var lbFilterError: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    
    lazy var dividasRN = DividaRN(delegate: self)
    var dividas = [Divida]()
    var selectedDivida = Divida()
    var qiwiFilters = QiwiStatementFilters()
    var isTodosSelected = true
    var isPendenteSelected = false
    var isVencidosSelected = false
    var isPagosSelected = false
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        
        self.tableView.dataSource = self
        
        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
    }
    
    override func setupViewWillAppear() {
        self.requestDividas()
    }
    
    func requestDividas() {
        Util.showLoading(self)
        
        self.viewFiltersSelecteds.isHidden = false
        self.viewFilters.isHidden = true
        
        var status = ""
        var requestStatus = 0
        if self.isTodosSelected {
            status = "Todos - "
            requestStatus = 0
        }
        else if self.isPagosSelected {
            status = "Pagos - "
            requestStatus = 2
        }
        else if self.isPendenteSelected {
            status = "Pendentes - "
            requestStatus = 1
        }
        else {
            status = "Vencidos - "
            requestStatus = 3
        }
        
        self.lbFilterName.text = status + self.qiwiFilters.getFilterName()
        self.lbFilterNameInside.text = status + self.qiwiFilters.getFilterName()
        
        if self.qiwiFilters.filter == .MONTH {
            self.dividasRN.getDividas(status: requestStatus, month: self.qiwiFilters.month, year: self.qiwiFilters.year)
        }
            
        else if self.qiwiFilters.filter == .LAST_15_DAYS {
            self.dividasRN.getDividas(status: requestStatus, daysBack: 15)
        }
            
        else if self.qiwiFilters.filter == .LAST_30_DAYS {
            self.dividasRN.getDividas(status: requestStatus, daysBack: 30)
        }
    }
}

extension DividasViewController {
    
    @IBAction func onClickStatus(_ sender: Any) {
        self.checkButton(btn: sender as! UIButton)
    }
    
    @IBAction func onClickCloseFilters(_ sender: Any) {
        self.viewFiltersSelecteds.isHidden = false
        self.viewFilters.isHidden = true
    }
    
    @IBAction func onClickRequestWithFilter(_ sender: Any) {
        self.requestDividas()
    }
    
    @IBAction func onClickChangePeriodo(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "qiwi_statement_choose_an_option".localized, preferredStyle: .actionSheet)
        
        // 2
        let last15Days = UIAlertAction(title: "qiwi_statement_last_15_days".localized, style: .default, handler: { action in
            self.qiwiFilters.filter = .LAST_15_DAYS
            self.requestDividas()
        })
        let last30Days = UIAlertAction(title: "qiwi_statement_last_30_days".localized, style: .default, handler: { action in
            self.qiwiFilters.filter = .LAST_30_DAYS
            self.requestDividas()
        })
        let selectMonth = UIAlertAction(title: "qiwi_statement_select_a_month".localized, style: .default, handler: { action in
            
            DispatchQueue.main.async {
                Util.showController(DatePickerViewController.self, sender: self, completion: { controller in
                    controller.delegate = self
                    controller.currentMonth = self.qiwiFilters.month
                    controller.currentYear = self.qiwiFilters.year
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
    
    @IBAction func displayFilters(sender: Any) {
        self.viewFilters.isHidden = false
        self.viewFiltersSelecteds.isHidden = true
    }
}

extension DividasViewController {
    
    func changeCheck(btn: UIButton, status: Bool) {
        
        switch btn {
            case btnFilterTodos:
                self.isTodosSelected = status
            break
            
            case btnFilterPendentes:
                self.isPendenteSelected = status
            break
            
            case btnFilterVencidas:
                self.isVencidosSelected = status
            break
            
            case btnFilterConcluidos:
                self.isPagosSelected = status
            break
            
            default:
                return
        }
        
        if !status {
            btn.setImage(Constants.Image.Button.CHECK_BOX_DISABLED, for: .normal)
            btn.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorGrey7)
            return
        }
        
        btn.setImage(Constants.Image.Button.CHECK_BOX_ENABLE, for: .normal)
        btn.imageView?.tintColor = UIColor(hexString: Constants.Colors.Hex.colorAccent)
    }
    
    func checkButton(btn: UIButton) {
        self.changeCheck(btn: self.btnFilterTodos, status: false)
        self.changeCheck(btn: self.btnFilterPendentes, status: false)
        self.changeCheck(btn: self.btnFilterVencidas, status: false)
        self.changeCheck(btn: self.btnFilterConcluidos, status: false)
        
        self.changeCheck(btn: btn, status: true)
    }
}

extension DividasViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
        DispatchQueue.main.async {
            
            if fromClass == DatePickerViewController.self {
                if param == Param.Contact.DATAPICKER_RESPONSE {
                    let monthAndYear = object as! String
                    self.qiwiFilters.setDate(monthAndYear: monthAndYear)
                    self.qiwiFilters.filter = .MONTH
                    self.requestDividas()
                }
            }
            
            if fromClass == DividaRN.self {
                if param == Param.Contact.DIVIDA_LIST_RESPONSE {
                    self.dismissPageAfter(after: 0.8)
                    
                    if result {
                        self.dividas = object as! [Divida]
                        self.tableView.reloadData()
                        
                        self.tableView.isHidden = false
                        self.viewNoContent.isHidden = true
                    }
                    
                    if !result || self.dividas.isEmpty {
                        self.tableView.isHidden = true
                        self.viewNoContent.isHidden = false
                    }
                }
            }
        }
    }
}

// MARK: Observer Height Collection
extension DividasViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        if keyPath == #keyPath(UITableView.contentSize) {
//            if let _ = object as? UITableView {
//                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
//                    self.heightTableView.constant = size.height
//                        return
//                }
//            }
//        }
    }
}

extension DividasViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.DIVIDA_DETAILS {
            
            // controller que sera apresentada
            if let navVC = segue.destination as? DividaDetailViewController {
                // passa o pedido de order pra frente
                navVC.selectedDivida = self.selectedDivida
                
                DividaDetailViewController.totalValue = self.selectedDivida.valueDivida
                DividaDetailViewController.partialTypeId = 0
                DividaDetailViewController.partialValue = 0
                DividaDetailViewController.partialReason = ""
                DividaDetailViewController.partialAnexos = [Anexo]()
            }
        }
    }
    
    @objc func showDetails(sender: UIButton) {
        
        // Item
        let currentItem = self.dividas[sender.tag]
        self.selectedDivida = currentItem
        
        // Proxima tela
        performSegue(withIdentifier: Constants.Segues.DIVIDA_DETAILS, sender: nil)
    }
}

// MARK: Data Table
extension DividasViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dividas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.section
        let currentItem = self.dividas[index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DividaCell
        cell.item = currentItem
        
//        let color = UIColor(hexString: index % 2 == 0 ? Constants.Colors.Hex.white : Constants.Colors.Hex.colorGrey2)
//        cell.viewContainer.backgroundColor = color
        
        // Index no button, para abrir detalhes
        cell.btnPay.tag = index
        cell.btnPay.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        
        cell.layer.masksToBounds = false
        cell.contentView.layer.masksToBounds = false
        
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

extension DividasViewController {
    
    func setupNib() {
        self.tableView.register(DividaCell.nib(), forCellReuseIdentifier: "Cell")
    }
}

extension DividasViewController : SetupUI {
    
    func setupUI() {
        Theme.default.textAsListTitle(self.lbTitle)
        Theme.default.backgroundCard(self)
        Theme.default.orageButton(self.btnFilter)
        
        self.qiwiFilters.filter = .LAST_15_DAYS
        
        self.checkButton(btn: self.btnFilterTodos)
    }
    
    func setupTexts() {
        self.lbTitle.text = "dividas_list_title".localized
        Util.setTextBarIn(self, title: "dividas_toolbar_title".localized)
    }
}
