//
//  PopoverProViewController.swift
//  MyQiwi
//
//  Created by Thyago on 17/10/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class PopoverProViewController: UIBaseViewController {
    
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbCost: UILabel!
    @IBOutlet weak var lbCredit: UILabel!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbTotalCommission: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var imgTotal: UIImageView!
    @IBOutlet weak var imgCommission: UIImageView!
    
    var countList = [ProValue]()
    
    override func setupViewDidLoad() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupUI()
        self.setupNib()
        self.handleLayout()
    }
    
    func handleLayout() {
        
        //self.handlerPin.layer.cornerRadius = 2
    }
}

extension PopoverProViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! PopoverBalanceCell
        
        let index = indexPath.row
        let item = self.countList[index]
        
        cell.item = item
        
        return cell
       }
}

extension PopoverProViewController {
    
    func setupNib() {
        self.tableView.register(PopoverBalanceCell.nib(), forCellReuseIdentifier: "Cell")
    }
}

extension PopoverProViewController : SetupUI {
    
    func setupUI() {
        
        Theme.default.textAsListTitle(self.lbDesc)
        Theme.default.textAsListTitle(self.lbCredit)
        Theme.default.textAsListTitle(self.lbCost)
        
        self.imgArrow.image = #imageLiteral(resourceName: "ic_arrow_up").withRenderingMode(.alwaysTemplate)
        self.imgArrow.tintColor = Theme.default.white
        
        self.imgTotal.image = #imageLiteral(resourceName: "ic_coin").withRenderingMode(.alwaysTemplate)
        self.imgTotal.tintColor = Theme.default.white
        self.imgCommission.image = #imageLiteral(resourceName: "ic_commission").withRenderingMode(.alwaysTemplate)
        self.imgCommission.tintColor = Theme.default.white
    }
    
    func setupTexts() {
        
    }
}
