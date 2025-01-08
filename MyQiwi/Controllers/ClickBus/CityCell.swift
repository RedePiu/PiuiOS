//
//  CityCell.swift
//  MyQiwi
//
//  Created by Thyago on 25/11/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class CityCell: UIBaseTableViewCell {

    @IBOutlet weak var lbCity: UILabel!
    
    var item: ClickBusCity! {
        
        didSet {
            
            self.lbCity.text = item.name
            
            self.setupNib()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lbCity.textColor = UIColor(hexString: Constants.Colors.Hex.colorGrey6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupNib() {
        //self.tableView.register(StatementItemCell.nib(), forCellReuseIdentifier: "Cell")
    }
}
