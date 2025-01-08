//
//  cellTableViewCell.swift
//  MyQiwi
//
//  Created by Ailton on 23/10/18.
//  Copyright © 2018 Qiwi. All rights reserved.
//

import UIKit

class StatementCell: UIBaseTableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var tableItems: UITableView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Variables
    var statementsTransactions: [StatementTransactions] = []
    var delegate: BaseDelegate?
    var transitionDate: String = ""
    
    var item: Statement! {
        
        didSet {
            
            guard let date = Date(item.date) else { return }
            
            self.lbDay?.text = date.toFormat("d MMMM yyyy")
            self.transitionDate = item.date
            
            let mutable = NSMutableAttributedString(string: "")
            mutable.append(NSAttributedString(string: "saldo do dia:", attributes: [NSAttributedStringKey.foregroundColor : Theme.default.greyCard]))
            mutable.append(NSAttributedString(string: Util.formatCoin(value: item.balance), attributes: [NSAttributedStringKey.foregroundColor : Theme.default.green]))
            
            self.lbBalance.attributedText = mutable
            self.statementsTransactions = item.items
            
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
        self.lbBalance.setupTitleMediumAccountQiwiBalance()
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
        self.tableView.register(StatementItemCell.nib(), forCellReuseIdentifier: "Cell")
    }
}

// MARK: Observer Height Collection
extension StatementCell {
    
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
        
        var objs = [AnyObject]()
        objs.append(self.statementsTransactions[button.tag] as StatementTransactions)
        objs.append(self.transitionDate as AnyObject)
        
        self.delegate?.onReceiveData(fromClass: StatementCell.self, param: Param.Contact.LIST_CLICK, result: true, object: objs as AnyObject)
    }
}

extension StatementCell : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statementsTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? StatementItemCell else {
            return UITableViewCell()
        }
        //
        let index = indexPath.row
        let item = self.statementsTransactions[index]
        cell.item = item
        
        cell.btnSeeOrder.tag = index
        cell.btnSeeOrder.addTarget(self, action: #selector(clickSeeOrder(button:)), for: .touchUpInside)
        
        let isQiwiBalance = item.value > 0
        cell.imgCircle.image = UIImage(named: isQiwiBalance ? "list_circle_item_green_solo" : "list_circle_item_solo")
        
        if self.statementsTransactions.count == 1 {
            cell.viewLineTop.alpha = 0
            cell.viewLineBottom.alpha = 0
        } else if index == 0 {
            cell.viewLineTop.alpha = 0
            cell.viewLineBottom.alpha = 1
        } else if index == self.statementsTransactions.count - 1 {
            cell.viewLineTop.alpha = 1
            cell.viewLineBottom.alpha = 0
        } else {
            cell.viewLineTop.alpha = 1
            cell.viewLineBottom.alpha = 1
        }
        
//        if self.statementsTransactions.count == 1 {
//            cell.imgCircle.image = UIImage(named: isQiwiBalance ? "list_circle_item_green_solo" : "list_circle_item_solo")
//        } else if index == 0 {
//            cell.imgCircle.image = UIImage(named: isQiwiBalance ? "list_circle_item_green_first" : "list_circle_item_first")
//        } else if index == self.statementsTransactions.count - 1 {
//            cell.imgCircle.image = UIImage(named: isQiwiBalance ? "list_circle_item_green_last" : "list_circle_item_last")
//        } else {
//            cell.imgCircle.image = UIImage(named: isQiwiBalance ? "list_circle_item_green" : "list_circle_item")
//        }
        
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

extension StatementCell : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        self.isEditingTableView = true
        //
        //        self.resetNavigation()
        //        self.setItensNavigation(indexPath: indexPath)
    }
}
