//
//  ExtractCellViewController.swift
//  MyQiwi
//
//  Created by Thiago Silva on 26/02/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class ExtractCellViewController: UITableViewCell {

    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var titleDescription: UILabel!
    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var lbDay: UILabel!
    
    var statementsTransactions: [StatementTransactions] = []
    //var delegate: BaseDelegate?
    
    var item: Statement! {
        
        didSet {
            //self.lbDay?.text = Util.formatDate(item.date)
            guard let date = Date(item.date) else { return }
            self.lbDay?.text = date.toFormat("d MMMM yyyy")
            
            let mutable = NSMutableAttributedString(string: "")
            mutable.append(NSAttributedString(string: "saldo do dia:", attributes: [NSAttributedStringKey.foregroundColor : Theme.default.greyCard]))
            mutable.append(NSAttributedString(string: Util.formatCoin(value: item.balance), attributes: [NSAttributedStringKey.foregroundColor : Theme.default.green]))
            
            self.statementsTransactions = item.items
            
            self.setupNib()
            self.prepareCell()
            
            // ContentSize TableView
           // self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        }
    }
    
    //override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    //}
    
    // MARK: Custom fuction
    
    func prepareCell() {
        
        self.lbDay.setupTitleMediumAccountQiwiDate()
        self.cornerView.layer.cornerRadius = 15
        self.cornerView.layer.borderWidth = 0.5
        self.cornerView.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        
        //self.tableView.reloadData()
    }
    
    func setupHeightTable() {
        
        //self.height.constant = self.tableView.contentSize.height + 20
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func setupNib() {
        //self.tableView.register(StatementItemCell.nib(), forCellReuseIdentifier: "Cell")
    }
}

extension ExtractCellViewController {
    
    func setupUI(){
        Theme.default.textAsListTitle(self.titleDescription)
    }
    
    func setupTexts() {
        self.btnDetails.setTitle("parking_see_details".localized, for: .normal)
    }
}
