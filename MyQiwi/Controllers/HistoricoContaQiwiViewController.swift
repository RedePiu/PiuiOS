//
//  HistoricoContaQiwiViewController.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 19/11/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class HistoricoContaQiwiViewController: UIBaseViewController {
    
    // MARK: Common Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbActiveFilters: UILabel!
    @IBOutlet weak var lbChangeFilter: UILabel!
    @IBOutlet weak var imgEnterArrow: UIImageView!
    
    @IBOutlet weak var lbFilterTitle: UILabel!
    @IBOutlet weak var btnCloseFilter: UIButton!
    
    @IBOutlet weak var lbStatusFilterOrders: UILabel!
    @IBOutlet weak var btnFilterCanceled: UIButton!
    @IBOutlet weak var btnFilterPedent: UIButton!
    @IBOutlet weak var btnFilterFinished: UIButton!
    @IBOutlet weak var lbFilterError: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    @IBOutlet weak var viewFilterStatus: UIView!
    @IBOutlet weak var viewFilterOrders: UIView!
    @IBOutlet weak var viewEmpty: ViewEmpty!
    @IBOutlet weak var viewOrders: UIView!
    @IBOutlet weak var viewLoading: UIView!
    
    lazy var orderDataHandler = OrderDataHandler(delegate: self)
    var isCanceled = true
    var isFinished = true
    var isPendent = true
    var selectedOrder = [0, 0]
    var isUpdating = false
    var isRequestingService = false
    var needUpdate = true
    
    override func setupViewDidLoad() {
        
        self.setupUI()
        self.setupTexts()
        self.setupLayout()
        self.setupNib()
        
        // Delegate, para ativar o refresh da lista
        self.scrollView.delegate = self

        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
    }
}

extension HistoricoContaQiwiViewController: BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        DispatchQueue.main.async {
            if (param == Param.Contact.ORDERS_ORDER_LIST_RESPONSE) {
                self.isRequestingService = false
                self.isUpdating = false
                
                if result {
                    self.viewEmpty.lbEmpty.text = "order_no_orders_title".localized
                    
                    self.tableView.reloadData()
                    self.viewOrders.isHidden = false
                    self.viewLoading.isHidden = true
                    self.viewEmpty.isHidden = true
                } else {
                    self.viewEmpty.lbEmpty.text = "order_no_orders_error_title".localized
                    
                    self.viewOrders.isHidden = true
                    self.viewLoading.isHidden = true
                    self.viewEmpty.isHidden = false
                }
                
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

// MARK: Observer Height Collection
extension HistoricoContaQiwiViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightTableView.constant = size.height
                    return
                }
            }
        }
    }
}

// MARK: Segue Idetifier
extension HistoricoContaQiwiViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.ORDER_DETAIL {
            if let vc = segue.destination as? OrderDetailViewController {
                
                self.needUpdate = false
                
                // Passa item
                vc.orderId = self.selectedOrder[0]
                vc.transitionId = self.selectedOrder[0]
            }
        }
    }
}

// MARK: Delegate ScrollView
extension HistoricoContaQiwiViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Caso nao esteja fazem um request no momento
        if !self.isRequestingService {
            
            let height = scrollView.frame.size.height
            let contentYoffset = scrollView.contentOffset.y
            let distanceFromBottom = scrollView.contentSize.height - contentYoffset
            
            // esta no fim da lista, estao solicitamos um novo request
            if distanceFromBottom < height {
                self.loadOrders(startFrom: self.orderDataHandler.arrItems.count)
                return
            }
            
            // Sendo negativo o contentOffset.y, acionar o refresh da lista
            if scrollView.contentOffset.y < -40 {
                
                // Ativar loading
                self.viewLoading.isHidden = false
                
                // Anima views
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
                
                //Faz o request
                self.loadOrders(startFrom: 0)
            }
        }
    }
}

// MARK: IBActions

extension HistoricoContaQiwiViewController {
    
    @IBAction func clickCloseFilter(sender: UIButton) {
        
        self.viewFilterStatus.isHidden = false
        self.viewFilterOrders.isHidden = true
        
        // Anima views
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func clickFilter(sender: UIButton) {
        
        // Nehum filtro marcado
        if !isCanceled && !isPendent && !isFinished {
            
            // Mostra texto
            self.lbFilterError.isHidden = false
            return
        }
        
        // Ocultar texto, para qualquer um marcado
        self.lbFilterError.isHidden = true
        
        self.orderDataHandler.arrItems = [Order]()
        self.orderDataHandler.orderFilters.updateValues(canceled: self.isCanceled, pendent: self.isPendent, finished: self.isFinished)
        self.loadOrders(startFrom: 0)
        
        // Ocultar view orders
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.clickCloseFilter(sender: sender)
        }
        
        // Anima views
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func clickCanceledFilter(sender: UIButton) {
        
        self.isCanceled = !self.isCanceled
        
        if isCanceled {
            Theme.Orders.textAsCheckBox(sender)
        }else {
            sender.setImage(#imageLiteral(resourceName: "ic_check_box_disable"), for: .normal)
        }
    }
    
    @IBAction func clickFinishedFilter(sender: UIButton) {
        
        self.isFinished = !self.isFinished
        
        if isFinished {
            Theme.Orders.textAsCheckBox(sender)
        }else {
            sender.setImage(#imageLiteral(resourceName: "ic_check_box_disable"), for: .normal)
        }
    }
    
    @IBAction func clickPendentFilter(sender: UIButton) {
        
        self.isPendent = !self.isPendent
        
        if isPendent {
            Theme.Orders.textAsCheckBox(sender)
        }else {
            sender.setImage(#imageLiteral(resourceName: "ic_check_box_disable"), for: .normal)
        }
    }
    
    @IBAction func openFilter(sender: UIButton) {
        
        // Não logado
        if !UserRN.hasLoggedUser() {
            
            // Mostra login
            Util.showNeedLogin(self)
            return
        }
        
        // Ocultar status, mostrar orders
        self.viewFilterStatus.isHidden = true
        self.viewFilterOrders.isHidden = false
        
        // Anima viewss
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func showDetailsOrder(sender: UIButton) {
        
        // Item
        let currentItem = orderDataHandler.cellForItemAtIndexPath(sender.tag)
        
        // Guardar
        self.selectedOrder[0] = currentItem.id
        self.selectedOrder[1] = currentItem.idTransaction
        
        // Proxima tela
        performSegue(withIdentifier: Constants.Segues.ORDER_DETAIL, sender: nil)
    }
}

// MARK: Load Orders
extension HistoricoContaQiwiViewController {
    
    fileprivate func loadOrders(startFrom: Int) {
        
        self.isRequestingService = true
        
        // Temporario
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.orderDataHandler.fillOrderList(startFrom: startFrom)
        }
    }
}

// MARK: Data Table
extension HistoricoContaQiwiViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderDataHandler.numberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.section
        
        // item
        let currentItem = orderDataHandler.cellForItemAtIndexPath(index)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? OrderCell else {
            return UITableViewCell()
        }
        cell.item = currentItem
        
        // Index no button, para abrir detalhes
        cell.btnDetails.tag = index
        cell.btnDetails.addTarget(self, action: #selector(showDetailsOrder(sender:)), for: .touchUpInside)
        
        cell.layer.masksToBounds = false
        cell.contentView.layer.masksToBounds = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 367
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        viewFooter.backgroundColor = UIColor.clear
        return viewFooter
    }
    
    
}

// MARK: Delegate Table
extension HistoricoContaQiwiViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


// MARK: SetupUI
extension HistoricoContaQiwiViewController: SetupUI {
    
    func setupNib() {
        self.tableView.register(OrderCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    func setupLayout() {

        self.lbFilterError.isHidden = true
        self.viewEmpty.isHidden = true
        self.viewOrders.isHidden = true
    }
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)

        Theme.Orders.textAsChangeFilter(self.lbChangeFilter)
        Theme.Orders.textAsActiveFilters(self.lbActiveFilters)
        Theme.Orders.textAsFilterTitle(self.lbFilterTitle)
        Theme.Orders.textAsFilterStatusOrders(self.lbStatusFilterOrders)
        Theme.Orders.textAsCheckBox(self.btnFilterCanceled)
        Theme.Orders.textAsCheckBox(self.btnFilterPedent)
        Theme.Orders.textAsCheckBox(self.btnFilterFinished)
        Theme.default.orageButton(self.btnFilter)

        Theme.Orders.setArrow(self.imgEnterArrow)
        Theme.Orders.setClose(self.btnCloseFilter)

        Theme.default.textAsError(self.lbFilterError)
    }
    
    func setupTexts() {

        self.lbActiveFilters.text = "order_searching_all".localized
        self.lbChangeFilter.text = "order_change_filter".localized
        self.viewEmpty.lbEmpty.text = "order_no_orders_title".localized

        self.lbFilterTitle.text = "order_filter_title".localized
        self.lbStatusFilterOrders.text = "order_filter_show_orders_label".localized
        self.btnFilterCanceled.setTitle("order_filter_canceled".localized, for: .normal)
        self.btnFilterPedent.setTitle("order_filter_pendent".localized, for: .normal)
        self.btnFilterFinished.setTitle("order_filter_finished".localized, for: .normal)

        self.lbFilterError.text = "order_filter_error".localized
        self.btnFilter.setTitle("order_filter_button".localized, for: .normal)
    }
}
