//
//  StatementItemCell.swift
//  MyQiwi
//
//  Created by Thyago on 27/06/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class UrbsStatementItemCell: UITableViewCell {

    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbLocal: UILabel!
    @IBOutlet weak var lbBalance: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbOp: UILabel!
    
    var item: UrbsRegistry! {
        
        didSet {
            
            let valor = item.value
            let salde = item.cardBalance
            
            self.lbDate.text = DateFormatterQiwi.formatDate(item.date, currentFormat: DateFormatterQiwi.defaultDatePattern, toFormat: "dd/MM/yy 'as' HH:mm")
            //self.lbLocal.text = "Local: " + item.line + " - " + item.trecho
            self.lbLocal.text = item.trecho.uppercased()
            self.lbBalance.text = "\(item.cardBalance)"
            self.lbValue.text = "\(item.value)"
            self.lbOp.text = item.operation
            
            self.lbBalance.text = Util.formatCoin(value: valor)
            self.lbValue.text = Util.formatCoin(value: salde)
            
            self.prepareCell()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Resetar style
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Custom fuction
    
    func prepareCell() {
        self.contentView.backgroundColor = UIColor.clear
        
        self.lbValue.setupTitleBoldSmall()
        self.lbOp.setupTitleBoldSmall()
        self.lbDate.setupTitleBoldSmall()
        self.lbLocal.setupTitleBoldSmall()
        self.lbBalance.setupTitleBoldSmall()
    }
}
