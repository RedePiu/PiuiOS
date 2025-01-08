//
//  ExtractViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 21/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ExtractViewController: UIBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    var statements: [Statement] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViewDidLoad() {
        self.setupUI()
        self.setupTexts()
        
        // ContentSize TableView
        self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.clear
    }
    
    func setupHeightTable() {
        
        self.height.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            //self.layoutIfNeeded()
        }
    }
    
    func setupNib() {
        self.tableView.register(StatementCell.nib(), forCellReuseIdentifier: "Cell")
    }
}

// MARK: Observer Height Collection



extension ExtractViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! StatementCell
        //
        let index = indexPath.row
        let item = self.statements[index]
        cell.item = item
        //cell.delegate = self
        
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
        return 80
    }
}

extension ExtractViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        self.isEditingTableView = true
        //
        //        self.resetNavigation()
        //        self.setItensNavigation(indexPath: indexPath)
    }
}

extension ExtractViewController{
    
    func setupUI() {
        
    }
    func setupTexts() {
        Util.setTextBarIn(self, title: "parking_view_extract".localized)
    }
}
