//
//  CreditTransferViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 16/01/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class CreditTransferViewController: UIBaseViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewLoading: UIView!
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        self.setupNib()
        //self.viewBalance.delegate = self
        
        // Delegate, para ativar o refresh da lista
        //self.scrollView.delegate = self
        //self.viewBalance.btnRecharge.addTarget(self, action: #selector(onClickRecharge), for: .touchUpInside)
        
        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.clear
    }
}


// MARK: SetupUI
extension AcountViewController: SetupUI {
    
    func setupUI() {
        
        Theme.default.backgroundCard(self)
        self.lblEmpty.setupMessageMedium()
    }
    
    func setupTexts() {
        self.lblEmpty.text = "statement_no_content".localized
    }
}
