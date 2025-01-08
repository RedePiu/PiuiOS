//
//  NotificationCell.swift
//  MyQiwi
//
//  Created by Thyago on 26/08/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

import UIKit

class NotificationCell: UIBaseTableViewCell {

    @IBOutlet weak var lbSubject: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgBell: UIImageView!
    
    var item: PushResponse! {
        
        didSet {
            
            self.prepareCell()
            
            self.lbSubject.text = item.message
            self.lbDate.text = Util.formatDate(item.date)
            //self.imgBell.image = UIImage.init()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func prepareCell() {
        
        self.lbSubject.setupTitleNormal()
        self.lbDate.setupDefaultTextStyle()
        //Util.formatDate(item.date)
    }
}
