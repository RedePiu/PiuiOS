//
//  OrderProItemCell.swift
//  MyQiwi
//
//  Created by Douglas Garcia on 10/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class OrderProItemCell : UIBaseTableViewCell {
    
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbComission: UILabel!
    @IBOutlet weak var btnReceipt: UIButton!
    
    var item: OrderPro! {
        
        didSet {
            
//
//            self.setupNib()
//            self.prepareCell()
//
//            // ContentSize TableView
//            self.tableView.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [.new], context: nil)
        }
    }
}
