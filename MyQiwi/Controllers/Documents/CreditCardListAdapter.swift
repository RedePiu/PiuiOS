//
//  CreditCardListAdapter.swift
//  MyQiwi
//
//  Created by Ailton Ramos on 19/10/21.
//  Copyright © 2021 Qiwi. All rights reserved.
//

import Foundation
import UIKit


class CreditCardListAdapter : NSObject {
    
    var viewController: UIBaseViewController
    var delegate: BaseDelegate
    var tableView: UITableView
    var heightTable: NSLayoutConstraint
    let height = CGFloat(50)
    var tokens = [CreditCardToken]()
    var listId = 0
    var isPendentCard = false
    var isFromPayment = false
    
    init(_ sender: UIBaseViewController, delegate: BaseDelegate, tableView: UITableView, heighTable: NSLayoutConstraint, tokens: [CreditCardToken], isPendentCard: Bool, isFromPayment: Bool = false) {
        
        
        self.viewController = sender
        self.delegate = delegate
        self.tableView = tableView
        self.heightTable = heighTable
        self.tokens = tokens
        self.isPendentCard = isPendentCard
        self.isFromPayment = isFromPayment
        
        super.init()
        
        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        
        self.tableView.register(ViewCreditCardTokenCell.nib(), forCellReuseIdentifier: "Cell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
}

extension CreditCardListAdapter {
    
    func setTokens(tokens: [CreditCardToken]) {
        self.tokens = tokens
        self.tableView.reloadData()
    }
    
    func getToken(index: Int) -> CreditCardToken? {
        
        if index < 0 || index >= self.tokens.count {
            return nil
        }
        
        return self.tokens[index]
    }
    
    func hasTokens() -> Bool {
        return !self.tokens.isEmpty
    }
    
    func getCount() -> Int {
        return self.tokens.count
    }
}

// MARK: Observer Height Collection
extension CreditCardListAdapter {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == #keyPath(UITableView.contentSize) {
            if let _ = object as? UITableView {
                if let size = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.heightTable.constant = size.height + 20
                    UIView.animate(withDuration: 0.3) {
                        self.viewController.view.layoutIfNeeded()
                    }
                    return
                }
            }
        }

        self.setupHeightTable()
    }
    
    func setupHeightTable() {
        self.heightTable.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            self.viewController.view.layoutIfNeeded()
        }
    }
}

// MARK: Data Table
extension CreditCardListAdapter: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tokens.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ViewCreditCardTokenCell

        let index = indexPath.row
        let item = self.tokens[index]
        cell.item = item

        cell.btnSelect.tag = index
        cell.btnSelect.alpha = self.isPendentCard || self.isFromPayment ? 1 : 0
        cell.btnSelect.addTarget(self, action: #selector(selectCard(sender:)), for: .touchUpInside)
        
        if self.isPendentCard {
            cell.btnSelect.text("confirm".localized)
        } else if isFromPayment {
            cell.btnSelect.text("credit_card_button_pay".localized)
        }

        //self.setupHeightTable()

        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension CreditCardListAdapter {
    
    @objc func selectCard(sender: UIButton) {
        
        if self.isPendentCard {
            self.delegate.onReceiveData(fromClass: CreditCardListAdapter.self, param: Param.Contact.CREDIT_CARD_CONFIRM_BUTTON_CLICKED, result: true, object: self.tokens[sender.tag] as AnyObject)
        }
        
        if self.isFromPayment {
            self.delegate.onReceiveData(fromClass: CreditCardListAdapter.self, param: Param.Contact.CREDIT_CARD_CONFIRM_BUTTON_CLICKED_FROM_PAYMENT, result: true, object: self.tokens[sender.tag] as AnyObject)
        }
    }
}


// MARK: Delegate Table
extension CreditCardListAdapter: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.isPendentCard {
            return
        }
        
        self.delegate.onReceiveData(fromClass: CreditCardListAdapter.self, param: Param.Contact.LIST_CLICK, result: true, object: indexPath.row as AnyObject)
    }
}
