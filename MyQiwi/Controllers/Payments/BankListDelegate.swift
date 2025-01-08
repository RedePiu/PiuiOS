//
//  BankListDelegate.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 22/04/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class BankListDelegate {
    
    var editPaymentController: EditPaymentsViewController
    var banks: [BankRequest]
    
    init(editPaymentController: EditPaymentsViewController) {
        self.editPaymentController = editPaymentController
    }
    
    
}

extension BankListDelegate {
    
    func removeCard(index: Int) {
        
    }
    
    func loadList() {
        //self.tableView.reloadData()
    }
    
    func setupHeightTable() {
//        self.heightTable.constant = self.tableView.contentSize.height + 20
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
    }
}

extension BankListDelegate : BaseDelegate {
    func onReceiveData(fromClass: AnyClass, param: Int, result: Bool, object: AnyObject?) {
        
    }
}

extension BankListDelegate : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.banks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ViewUserBankCell
        
        let index = indexPath.row
        let item = self.banks[index]
        cell.item = item
        
        cell.btnCharge.tag = index
        cell.btnCharge.addTarget(self, action: #selector(bankSelected(sender:)), for: .touchUpInside)
        
        self.setupHeightTable()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.editPaymentController.height
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

extension BankListDelegate {
    @objc func bankSelected(sender: UIButton) {
        let selectedBank = self.banks[sender.tag]
    }
}
