//
//  ReceiptCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 02/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ReceiptCell: UIBaseTableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var tableItems: UITableView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var receipts: [Receipt] = []
    var delegate: BaseDelegate?
    var transitionDate: String = ""
    
    var item: ReceiptGroup! {
        
        didSet {
            //self.lbDay?.text = Util.formatDate(item.date)
            guard let date = Date(item.date) else { return }
            self.lbDay?.text = date.toFormat("d MMMM yyyy")
            self.transitionDate = item.date
            
            self.receipts = item.receipts

            self.setupNib()
            self.prepareCell()

            // ContentSize TableView
            self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Custom fuction
    
    func prepareCell() {
        
        self.lbDay.setupTitleMediumAccountQiwiDate()
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
        self.tableView.register(ReceiptItemCell.nib(), forCellReuseIdentifier: "Cell")
    }
}

// MARK: Observer Height Collection
extension ReceiptCell {
    
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
    
    @objc func clickSeeOrder(button: UIButton) {
        let id = Int(self.receipts[button.tag].transitionId)
        
        var objs = [AnyObject]()
        objs.append(id as AnyObject)
        objs.append(self.transitionDate as AnyObject)
        
        self.delegate?.onReceiveData(fromClass: ReceiptCell.self, param: Param.Contact.LIST_CLICK, result: true, object: objs as AnyObject)
    }
}

extension ReceiptCell : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ReceiptItemCell
        //
        let index = indexPath.row
        let item = self.receipts[index]
        cell.item = item
        
        cell.btnSeeOrder.tag = index
        cell.btnSeeOrder.addTarget(self, action: #selector(clickSeeOrder(button:)), for: .touchUpInside)
        
        if self.receipts.count == 1 {
            cell.imgCircle.image = UIImage(named: "list_circle_item_solo")
        } else if index == 0 {
            cell.imgCircle.image = UIImage(named: "list_circle_item_first")
        } else if index == self.receipts.count - 1 {
            cell.imgCircle.image = UIImage(named: "list_circle_item_first")
        } else {
            cell.imgCircle.image = UIImage(named: "list_circle_item")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension ReceiptCell : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        self.isEditingTableView = true
        //
        //        self.resetNavigation()
        //        self.setItensNavigation(indexPath: indexPath)
    }
}

