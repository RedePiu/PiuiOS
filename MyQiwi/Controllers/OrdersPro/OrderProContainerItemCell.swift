//
//  OrderProContainerItemCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class OrderProContainerItemCell : UIBaseTableViewCell {
    
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var orders = [OrderPro]()
    var delegate: BaseDelegate?
    var transitionDate: String = ""
    var isAll = false
    
    var item: OrderProContainer! {
        
        didSet {
//            self.lbDay?.text = Util.formatDate(item.date)
            guard let date = Date(item.date) else { return }
            
            self.lbDate?.text = date.toFormat("d MMMM yyyy")
            self.transitionDate = item.date
            
            self.orders = item.items
            
            self.setupNib()
            self.prepareCell()
//           self.setupHeightTable()
            
            // ContentSize TableView
            self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
            
            self.updateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    // MARK: Custom fuction
    
    func prepareCell() {
        
        self.lbDate.setupTitleMediumAccountQiwiDate()
        self.cornerView.layer.cornerRadius = 15
        self.cornerView.layer.borderWidth = 0.5
        self.cornerView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        self.tableView.reloadData()
    }
    
    func setupHeightTable() {
        
        self.height.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func setupNib() {
        self.tableView.register(OrderProItemCell.nib(), forCellReuseIdentifier: "Cell")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.height.constant = size.height
                    self.updateConstraints()
                    self.layoutIfNeeded()
                    return
                }
            }
        }
        
        self.height.constant = self.tableView.contentSize.height
        self.updateConstraints()
        self.layoutIfNeeded()
    }
    
    @objc func openDetails(sender: UIButton) {
        self.delegate?.onReceiveData(fromClass: OrderProContainerItemCell.self, param: Param.Contact.LIST_CLICK, result: true, object: self.orders[sender.tag])
    }
}

extension OrderProContainerItemCell : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OrderProItemCell
        //
        let index = indexPath.row
        let item = self.orders[index]
        cell.item = item
        
//        cell.btnSeeOrder.tag = index
//        cell.btnSeeOrder.addTarget(self, action: #selector(clickSeeOrder(button:)), for: .touchUpInside)
        
        cell.lbDesc.text = item.product
        cell.lbValue.text = Util.formatCoin(value: item.value)
        cell.lbComission.text = Util.formatCoin(value: item.commission)
        
        cell.btnReceipt.tag = index
        cell.btnReceipt.addTarget(self, action: #selector(openDetails(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension - 60
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }

    private func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    private func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
}
